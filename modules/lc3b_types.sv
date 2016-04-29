package lc3b_types;

typedef logic [127:0] pmem_bus;
typedef logic [127:0] pmem_L1_bus;

typedef logic [15:0] lc3b_word;
typedef logic  [7:0] lc3b_byte;
typedef logic  [2:0] lc3b_rob_addr;
typedef logic  [8:0] lc3b_offset9;
typedef logic  [5:0] lc3b_offset6;
typedef logic [4:0] lc3b_imm5;
typedef logic [3:0] lc3b_imm4;
typedef logic [7:0] lc3b_trapvect8;
typedef logic [10:0] lc3b_offset11;

typedef logic [2:0] lc3b_bht_ind;
typedef logic [3:0] lc3b_bht_out;
typedef logic [6:0] lc3b_pht_ind;

typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;

/* Cache types */
typedef logic [4:0] icache_tag;
typedef logic [6:0] icache_index;
typedef logic [2:0] icache_offset;

typedef logic [8:0] dcache_tag;
typedef logic [2:0] dcache_index;
typedef logic [2:0] dcache_offset;

typedef logic [1:0] L2cache_tag;
typedef logic [9:0] L2cache_index;
//typedef logic [0:0] L2cache_offset;

/* BTB types */
typedef logic [8:0] btb_tag;
typedef logic [5:0] btb_index;


typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [3:0] {
    alu_add,
    alu_and,
    alu_not,
    alu_pass,
    alu_sll,
    alu_srl,
    alu_sra,
	alu_sub,
	alu_xor,
	alu_or, 
	alu_nand,
	alu_nor,
	alu_xnor
} lc3b_aluop;


/* Struct for the common data bus(CDB)*/
typedef struct packed 
{
	logic valid;
	logic [15:0] data;
	logic [2:0] tag;
} CDB;

typedef struct packed
{
	logic busy;
	lc3b_reg rob_entry;
	lc3b_word data; 
} regfile_t;

parameter num_RS_units = 4;

parameter num_mult_cycles = 2;
parameter num_div_cycles = 10;


endpackage : lc3b_types





