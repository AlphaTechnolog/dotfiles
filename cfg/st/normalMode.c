#include <X11/keysym.h>
#include <X11/XKBlib.h>

#include "normalMode.h"
#include "utils.h"

extern Glyph const styleSearch, style[];
extern char const wDelS[], wDelL[], *nmKeys[];
extern unsigned int bg[], fg, currentBg, highlightBg, highlightFg, amountNmKeys;

typedef struct { int p[3]; } Pos;

typedef enum {visual='v', visualLine='V', yank = 'y'} Op;
typedef enum {infix_none=0, infix_i='i', infix_a='a'} Infix;
typedef enum {fw='/', bw='?'} Search;
struct NormalModeState {
	struct OperationState { Op op; Infix infix; } cmd;
	struct MotionState { uint32_t c; int active; Pos searchPos; Search search; } m;
} defaultNormalMode, state;

DynamicArray searchStr=UTF8_ARRAY, cCmd=UTF8_ARRAY, lCmd=UTF8_ARRAY;
Glyph styleCmd;
char posBuffer[10], braces[6][3] = { {"()"}, {"<>"}, {"{}"}, {"[]"}, {"\"\""}, {"''"}};
int exited=1, overlay=1;
static inline Rune cChar() { return term.line[term.c.y][term.c.x].u; }
static inline int pos(int p, int h) {return IS_SET(MODE_ALTSCREEN)?p:rangeY(p+h*histOff-insertOff);}
static inline int contains(Rune l, char const * values, size_t const memSize) {
	for (uint32_t i = 0; i < memSize; ++i) if (l == values[i]) return 1;
	return 0;
}
static inline void decodeTo(char const *cs, size_t len, DynamicArray *arr) {
	char *var = expand(arr);
	if (!var) empty(arr); else utf8decode(cs, (Rune*)(var), len);
}
static inline void applyPos(Pos p) {
	term.c.x = p.p[0], term.c.y = p.p[1];
	if (!IS_SET(MODE_ALTSCREEN) && histOp) term.line = &buf[histOff = p.p[2]];
}
/// Find string in history buffer, and provide string-match-lookup for highlighting matches
static int highlighted(int x, int y) {
	int const s=term.row*term.col, i=y*term.col+x, sz=size(&searchStr);
	return sz && i<s && mark[i]!=sz && i+mark[i]<s && !mark[i+mark[i]];
}
static void markSearchMatches(int all) {
	int sz = size(&searchStr), ox = 0, oy = 0, oi=0;
	for (int y=0; sz && all && y<term.row; ++y)
		for (int x=0; x<term.col; ++x) term.dirty[y] |= highlighted(x, y);
	for (int y = 0, wi=0, owi=0, i=0; sz && y < term.row; ++y)
		for (int x=0; x<term.col; ++x, wi%=sz, ++i, owi=wi)
			if (all || term.dirty[y]) {
				mark[i]=sz-(wi=(getU32(&searchStr,wi,1)==term.line[y][x].u?wi+1:0));
				if (wi==1) ox=x, oy=y, oi=i; else if (!wi && owi) x=ox, y=oy, i=oi;
			}
	for (int y=0; sz &&all &&y<term.row; ++y)
		for (int x=0; x<term.col; ++x) term.dirty[y] |= highlighted(x, y);
}
static int findString(int s, int all) {
	Pos p = (Pos) {.p={term.c.x, term.c.y, IS_SET(MODE_ALTSCREEN) ? 0 : histOff}};
	historyMove(s, 0, 0);
	uint32_t strSz=size(&searchStr), maxIter=rows()*term.col+strSz, wIdx=0;
	for (uint32_t i=0, wi = 0; wIdx<strSz && ++i<=maxIter; historyMove(s, 0, 0), wi=wIdx) {
		wIdx = (getU32(&searchStr, wIdx, s>0)==cChar())?wIdx+1:0;
		if (wi && !wIdx) historyMove(-(int)(s*wi), 0, 0);
	}
	if (wIdx == strSz && wIdx) historyMove(-(int)(s*strSz), 0, 0);
	else applyPos(p);
	markSearchMatches(all);
	return wIdx == strSz;
}
/// Execute series of normal-mode commands from char array / decoded from dynamic array
ExitState pressKeys(char const* s, size_t e) {
	ExitState x=success;
	for (size_t i=0; i<e && (x=(!s[i] ? x : kPressHist(&s[i], 1, 0, NULL))); ++i);
	return x;
}
static ExitState executeCommand(uint32_t *cs, size_t z) {
	ExitState x=success;
	char dc [32];
	for (size_t i=0; i<z && (x=kPressHist(dc, utf8encode(cs[i],dc),0,NULL));++i);
	return x;
}
/// Get character for overlay, if the overlay (st) has something to show, else normal char.
static void getChar(DynamicArray *st, Glyph *glyphChange, int y, int xEnd, int width, int x) {
	if (x < xEnd - min(min(width,xEnd), size(st))) *glyphChange = term.line[y][x];
	else if (x<xEnd) glyphChange->u = *((Rune*)(st->content + (size(st)+x-xEnd)*st->elSize));
}
/// Expand "infix" expression: for instance (w =>)       l     b     |   | v     e    |   | y
static ExitState expandExpression(char l) { //    ({ =>)       l  ?  {  \n | l | v  /  } \n | h | y
	int a=state.cmd.infix==infix_a, yank=state.cmd.op=='y', lc=tolower(l), found=1;
	state.cmd.infix = infix_none;
	if(!yank && state.cmd.op!=visual && state.cmd.op!=visualLine) return failed;
	char mot[11] = {'l', 0, 'b', 0, 0, 'v', 0, 'e', 0, 0, (char)(yank ? 'y' : 0)};
	if (lc == 'w') mot[2] = (char) ('b' - lc + l), mot[7] = (char) ((a ? 'w' : 'e') - lc + l), mot[9]=(char)(a?'h':0);
	else {
		mot[1]='?', mot[3]=mot[8]='\n', mot[6]='/', mot[4]=(char)(a?0:'l'), mot[9]=(char)(a?0:'h');
		for (int i=found=0; !found && i < 6; ++i)
			if ((found=contains(l,braces[i],2))) mot[2]=braces[i][0], mot[7]=braces[i][1];
	}
	if (!found) return failed;
	assign(&lCmd, &cCmd);
	empty(&cCmd);
	state.cmd = defaultNormalMode.cmd;
	return pressKeys(mot, 11);
}

ExitState executeMotion(char const cs, KeySym const *const ks) {
	state.m.c = state.m.c < 1u ? 1u : state.m.c;
	if      (ks && *ks == XK_d) historyMove(0, 0, term.row / 2);
	else if (ks && *ks == XK_u) historyMove(0, 0, -term.row / 2);
	else if (ks && *ks == XK_f) historyMove(0, 0, term.row-1+(term.c.y=0));
	else if (ks && *ks == XK_b) historyMove(0, 0, -(term.c.y=term.row-1));
	else if (ks && *ks == XK_h) overlay = !overlay;
	else if (cs == 'K') historyMove(0, 0, -(int)state.m.c);
	else if (cs == 'J') historyMove(0, 0,  (int)state.m.c);
	else if (cs == 'k') historyMove(0, -(int)state.m.c, 0);
	else if (cs == 'j') historyMove(0,  (int)state.m.c, 0);
	else if (cs == 'h') historyMove(-(int)state.m.c, 0, 0);
	else if (cs == 'l') historyMove( (int)state.m.c, 0, 0);
	else if (cs == 'H') term.c.y = 0;
	else if (cs == 'M') term.c.y = term.bot / 2;
	else if (cs == 'L') term.c.y = term.bot;
	else if (cs == 's' || cs == 'S') altToggle = cs == 's' ? !altToggle : 1;
	else if (cs == 'G' || cs == 'g') {
		if (cs == 'G') term.c = c[0] = c[IS_SET(MODE_ALTSCREEN)+1];
		if (!IS_SET(MODE_ALTSCREEN)) term.line = &buf[histOff=insertOff];
	} else if (cs == '0') term.c.x = 0;
	else if (cs == '$') term.c.x = term.col-1;
	else if (cs == 't') sel.type = sel.type==SEL_REGULAR ? SEL_RECTANGULAR : SEL_REGULAR;
	else if (cs == 'n' || cs == 'N') {
		int const d = ((cs=='N')!=(state.m.search==bw))?-1:1;
		for (uint32_t i = state.m.c; i && findString(d, 0); --i);
	} else if (contains(cs, "wWeEbB", 6)) {
		int const low=cs<=90, off=tolower(cs)!='w', sgn=(tolower(cs)=='b')?-1:1;
		size_t const l=strlen(wDelL), s=strlen(wDelS), maxIt=rows()*term.col;
		for (int it=0, on=0; state.m.c > 0 && it < maxIt; ++it) {
		    // If an offset is to be performed in beginning or not in beginning, move in history.
			if ((off || it) && historyMove(sgn, 0, 0)) break;
			// Determine if the category of the current letter changed since last iteration.
			int n = 1<<(contains(cChar(),wDelS,s) ?(2-low) :!contains(cChar(),wDelL,l)),
			    found = (on|=n)^n && ((off ?on^n :n)!=1);
			// If a reverse offset is to be performed and this is the last letter:
			if (found && off) historyMove(-sgn, 0, 0);
			// Terminate iteration: reset #it and old n value #on and decrease operation count:
			if (found) it=-1, on=0, --state.m.c;
		}
	} else return failed;
	state.m.c = 0;
	return state.cmd.op == yank ? exitMotion : success;
}

ExitState kPressHist(char const *cs, size_t len, int ctrl, KeySym const *kSym) {
	historyOpToggle(1, 1);
	int const prevYOff=IS_SET(MODE_ALTSCREEN)?0:histOff, search=state.m.search&&state.m.active,
	          prevAltToggle=altToggle, prevOverlay=overlay;
	int const noOp=!state.cmd.op&&!state.cmd.infix, num=len==1&&BETWEEN(cs[0],48,57),
	          esc=kSym&&*kSym==XK_Escape, ret=(kSym&&*kSym==XK_Return)||(len==1&&cs[0]=='\n'),
	          quantifier=num&&(cs[0]!='0'||state.m.c), ins=!search &&noOp &&len &&cs[0]=='i';
	exited = 0;
	ExitState result = success;
	if (esc || ret || ins) { result = exitMotion, len = 0;
	} else if (kSym && *kSym == XK_BackSpace) {
		if ((search || state.m.c) && size(&cCmd)) pop(&cCmd);
		if (search) {
			if (size(&searchStr)) pop(&searchStr);
			else result = exitMotion;
			if (!size(&searchStr)) tfulldirt();
			applyPos(state.m.searchPos);
			findString(state.m.search==fw ? 1 : -1, 1);
		} else if (state.m.c) state.m.c /= 10;
		len = 0;
	} else if (search) {
		if (len >= 1) decodeTo(cs, len, &searchStr);
		applyPos(state.m.searchPos);
		findString(state.m.search==fw ? 1 : -1, 1);
	} else if (len == 0) { result = failed;
	} else if (quantifier) { state.m.c = min(SHRT_MAX, (int)state.m.c*10+cs[0]-48);
	} else if (state.cmd.infix && state.cmd.op && (result = expandExpression(cs[0]), len=0)) {
    } else if (cs[0] == 'd') { state = defaultNormalMode; result = exitMotion; state.m.active = 1;
	} else if (cs[0] == '.') {
		if (size(&cCmd)) assign(&lCmd, &cCmd);
		empty(&cCmd);
		executeCommand((uint32_t*) lCmd.content, size(&lCmd));
		empty(&cCmd);
		len = 0;
	} else if (cs[0] == 'r') { tfulldirt();
	} else if (cs[0] == 'c') {
		empty(&lCmd);
		empty(&cCmd);
		empty(&searchStr);
		tfulldirt();
		len = 0;
	} else if (cs[0] == fw || cs[0] == bw) {
		empty(&searchStr);
		state.m.search = (Search) cs[0];
		state.m.searchPos = (Pos){.p={term.c.x, term.c.y, prevYOff}};
		state.m.active = 1;
	} else if (cs[0]==infix_i || cs[0]==infix_a) { state.cmd.infix=(Infix) cs[0];
	} else if (cs[0] == 'y') {
		if (state.cmd.op) {
			result = (state.cmd.op == yank || state.cmd.op == visualLine) ? exitOp : exitMotion;
			if (state.cmd.op == yank) selstart(0, term.c.y, 0);
		} else selstart(term.c.x, term.c.y, 0);
		state.cmd.op = yank;
	} else if (cs[0] == visual || cs[0] == visualLine) {
		if (state.cmd.op != (Op) cs[0]) {
			state.cmd = defaultNormalMode.cmd;
			state.cmd.op = (Op) cs[0];
			selstart(cs[0] == visualLine ?0 :term.c.x, term.c.y, 0);
		} else result = exitOp;
	} else if (!(result =executeMotion((char) (len?cs[0]:0), ctrl?kSym:NULL))) {
		result=failed;
		for (size_t i = 0; !ctrl && i < amountNmKeys; ++i)
			if (cs[0]==nmKeys[i][0] &&
			   failed!=(result=pressKeys(&nmKeys[i][1], strlen(nmKeys[i])-1))) goto end;
	} // Operation/Motion finished if valid: update cmd string, extend selection, update search
	if (result != failed) {
		if (len == 1 && !ctrl) decodeTo(cs, len, &cCmd);
		if ((state.cmd.op == visualLine) || ((state.cmd.op == yank) && (result == exitOp))) {
			int const off = term.c.y + (IS_SET(MODE_ALTSCREEN) ? 0 : histOff) < sel.ob.y; //< Selection start below end.
			sel.ob.x = off ? term.col - 1 : 0;
			selextend(off ? 0 : term.col-1, term.c.y, sel.type, 0);
		} else if (sel.oe.x != -1) {
			selextend(term.c.x, term.c.y, sel.type, 0);
		}
	} // Set repaint for motion or status bar
	if (!IS_SET(MODE_ALTSCREEN) && prevYOff != histOff) tfulldirt();
	// Terminate Motion / operation if thus indicated
	if (result == exitMotion) {
		if (!state.m.active) result = (exited=noOp) ? finish : exitOp;
		 state.m.active = (int) (state.m.c = 0u);
	}
	if (result == exitOp || result == finish) {
		if (state.cmd.op == yank) {
			xsetsel(getsel());
			xclipcopy();
		}
		state = defaultNormalMode;
		selclear();
		if (!esc) assign(&lCmd, &cCmd);
		empty(&cCmd);
	} // Update the content displayed in the history overlay
	styleCmd = style[state.cmd.op==yank ? 1 : (state.cmd.op==visual ? 2 :
	                (state.cmd.op==visualLine ? 3 :0))];
	int const posLin = !IS_SET(MODE_ALTSCREEN) ? rangeY(insertOff-histOff):0, h=rows()-term.row;
	if (!posLin || posLin==h || !h) strcpy(posBuffer, posLin ? " [BOT] " : " [TOP] ");
	else sprintf(posBuffer, " % 3d%c  ", min(100, max(0, (int)(.5 + posLin * 100. / h))),'%');
	if ((overlay || overlay!=prevOverlay) && term.col>9 && term.row>4) {
		if (!term.dirty[term.row-1]) xdrawline(term.line[term.row-1], term.col*2/3, term.row-1, term.col-1);
		if (!term.dirty[term.row-2]) xdrawline(term.line[term.row-2], term.col*2/3, term.row-2, term.col-1);
	}
	if (result==finish) altToggle = 0;
	if (altToggle != prevAltToggle) tswapscreen();
end:
	historyOpToggle(-1, 1);
	return result;
}

void historyOverlay(int x, int y, Glyph* g) {
	if (!histMode) return;
	TCursor const *cHist = histOp ? &term.c : &c[0];
	if(overlay && term.col > 9 && term.row > 4 && (x > (2*term.col/3)) && (y >= (term.row-2))) {
		*g = (y == term.row - 2) ? styleSearch : styleCmd;
		if (y == term.row-2) getChar(&searchStr, g, term.row-2, term.col-2, term.col/3, x);
		else if (x > term.col - 7) g->u = (Rune)(posBuffer[x - term.col + 7]);
		else getChar(size(&cCmd) ?&cCmd :&lCmd, g, term.row-1, term.col-7, term.col/3-6, x);
	} else if (highlighted(x, y)) g->bg = highlightBg, g->fg = highlightFg;
	else if ((x==cHist->x) ^ (y==cHist->y)) g->bg = currentBg;
	else if (x==cHist->x) g->mode^=ATTR_REVERSE;
}
void historyPreDraw() {
	static Pos op = {.p={0, 0, 0}};
	historyOpToggle(1, 0);
	// Draw the cursor cross if changed
	if (term.c.y >= term.row || op.p[1] >= term.row) tfulldirt();
	else if (exited || (op.p[1] != term.c.y)) term.dirty[term.c.y] = term.dirty[op.p[1]] = 1;
	for (int i=0; (exited || term.c.x != op.p[0]) && i<term.row; ++i) if (!term.dirty[i]) {
		xdrawline(term.line[i], term.c.x, i, term.c.x + 1);
		xdrawline(term.line[i], op.p[0], i, op.p[0] + 1);
	}
	// Update search results either only for lines with new content or all results if exiting
	markSearchMatches(exited);
	op = (Pos){.p = {term.c.x, term.c.y, 0}};
	historyOpToggle(-1, 0);
}
