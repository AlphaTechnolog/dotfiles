/// Dynamic memory-chunk, with (1) datatype size, (2/3) initialized / allocated chunk, (4) content
typedef struct { uint8_t const elSize; uint32_t init, alloc; char* content; } DynamicArray;
#define UTF8_ARRAY {4, 0, 0, NULL}

static inline int p_alloc(DynamicArray *s, uint32_t amount) {
	uint32_t const diff=s->init+s->elSize*amount-s->alloc, nas=s->alloc+max(diff,15)*s->elSize;
	if (s->alloc < s->init + s->elSize * amount) {
		char* tmp = realloc(s->content, nas);
		if (!tmp) return 0;
		s->alloc = nas, s->content = tmp;
	}
	return 1;
}
static inline char *view(DynamicArray * s, uint32_t i) { return s->content + i*s->elSize; }
static inline char *end(DynamicArray *s, uint32_t i) { return s->content +s->init-(i+1)*s->elSize; }
static inline uint32_t getU32(DynamicArray* s, uint32_t i, int b) { return *((uint32_t*) (b ?view(s,i) :end(s,i))); }
static char *expand(DynamicArray *s) { if (!p_alloc(s, 1)) return NULL; s->init += s->elSize; return end(s, 0); }
static inline void pop(DynamicArray* s) { s->init -= s->elSize; }
static inline void empty(DynamicArray* s) { s->init = 0; }
static inline int size(DynamicArray const * s) { return s->init / s->elSize; }
static inline void assign(DynamicArray* s, DynamicArray const *o) { 
	if (p_alloc(s, size(o))) memcpy(s->content, o->content, (s->init=o->init));
}
