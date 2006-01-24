/* A Bison parser, made by GNU Bison 1.875d.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Written by Richard Stallman by simplifying the original so called
   ``semantic'' parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LIBRO = 258,
     PARTE = 259,
     TITOLO = 260,
     CAPO = 261,
     SEZIONE = 262,
     ARTICOLO = 263,
     COMMA = 264,
     CAPOVERSO = 265,
     LETTERA = 266,
     NUMERO = 267,
     PARAGRAFO = 268,
     PERIODO = 269,
     COSTITUZIONE = 270,
     DECRETO_PRESIDENTE_REPUBBLICA = 271,
     DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI = 272,
     DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI = 273,
     ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI = 274,
     LEGGE_COSTITUZIONALE = 275,
     LEGGE = 276,
     DECRETO_LEGGE = 277,
     DECRETO_LEGISLATIVO = 278,
     REGIO_DECRETO = 279,
     REGIO_DECRETO_LEGGE = 280,
     REGIO_DECRETO_LEGISLATIVO = 281,
     CODICE_CIVILE = 282,
     CODICE_PROCEDURA_CIVILE = 283,
     CODICE_PENALE = 284,
     CODICE_PROCEDURA_PENALE = 285,
     LEGGE_REGIONALE = 286,
     REGOLAMENTO_REGIONALE = 287,
     REGIONE = 288,
     PAROLA_REGIONE = 289,
     UE_NUM = 290,
     UE_DEN = 291,
     PARLAMENTO = 292,
     CONSIGLIO = 293,
     COMMISSIONE = 294,
     DIRETTIVA = 295,
     DECISIONE = 296,
     REGOLAMENTO = 297,
     DATA_GG_MM_AAAA = 298,
     NUMERO_CARDINALE = 299,
     CITATO = 300,
     DEL = 301,
     DELL = 302,
     DELLA = 303,
     E = 304,
     IN_DATA = 305,
     BARRA = 306,
     PAROLA = 307,
     BREAK = 308
   };
#endif
#define LIBRO 258
#define PARTE 259
#define TITOLO 260
#define CAPO 261
#define SEZIONE 262
#define ARTICOLO 263
#define COMMA 264
#define CAPOVERSO 265
#define LETTERA 266
#define NUMERO 267
#define PARAGRAFO 268
#define PERIODO 269
#define COSTITUZIONE 270
#define DECRETO_PRESIDENTE_REPUBBLICA 271
#define DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI 272
#define DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI 273
#define ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI 274
#define LEGGE_COSTITUZIONALE 275
#define LEGGE 276
#define DECRETO_LEGGE 277
#define DECRETO_LEGISLATIVO 278
#define REGIO_DECRETO 279
#define REGIO_DECRETO_LEGGE 280
#define REGIO_DECRETO_LEGISLATIVO 281
#define CODICE_CIVILE 282
#define CODICE_PROCEDURA_CIVILE 283
#define CODICE_PENALE 284
#define CODICE_PROCEDURA_PENALE 285
#define LEGGE_REGIONALE 286
#define REGOLAMENTO_REGIONALE 287
#define REGIONE 288
#define PAROLA_REGIONE 289
#define UE_NUM 290
#define UE_DEN 291
#define PARLAMENTO 292
#define CONSIGLIO 293
#define COMMISSIONE 294
#define DIRETTIVA 295
#define DECISIONE 296
#define REGOLAMENTO 297
#define DATA_GG_MM_AAAA 298
#define NUMERO_CARDINALE 299
#define CITATO 300
#define DEL 301
#define DELL 302
#define DELLA 303
#define E 304
#define IN_DATA 305
#define BARRA 306
#define PAROLA 307
#define BREAK 308




/* Copy the first part of user declarations.  */
#line 11 "riferimenti.y"

#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"

#include "urn.h"

int errore = 0;

int yydebug = 0;		/* per debug */

urn urnTmp;
int pos = 0;
extern char * yytext;
extern int yyleng;

void yyerror(const char *str) {
	//loggerDebug(utilConcatena(3, str, " -> ", yytext));
	//fprintf(stderr, "error: %s -> %s\n", str, yytext);
}

int yywrap() {
	return 1;
}





/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 214 of yacc.c.  */
#line 226 "riferimenti.tab.c"

#if ! defined (yyoverflow) || YYERROR_VERBOSE

# ifndef YYFREE
#  define YYFREE free
# endif
# ifndef YYMALLOC
#  define YYMALLOC malloc
# endif

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   define YYSTACK_ALLOC alloca
#  endif
# else
#  if defined (alloca) || defined (_ALLOCA_H)
#   define YYSTACK_ALLOC alloca
#  else
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
# endif
#endif /* ! defined (yyoverflow) || YYERROR_VERBOSE */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (defined (YYSTYPE_IS_TRIVIAL) && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short int yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short int) + sizeof (YYSTYPE))			\
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined (__GNUC__) && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif

#if defined (__STDC__) || defined (__cplusplus)
   typedef signed char yysigned_char;
#else
   typedef short int yysigned_char;
#endif

/* YYFINAL -- State number of the termination state. */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   141

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  54
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  63
/* YYNRULES -- Number of rules. */
#define YYNRULES  129
/* YYNRULES -- Number of states. */
#define YYNSTATES  174

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   308

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short int yyprhs[] =
{
       0,     0,     3,     6,     8,    10,    12,    14,    16,    18,
      20,    23,    27,    29,    31,    33,    35,    37,    39,    41,
      43,    45,    47,    49,    51,    53,    55,    57,    59,    61,
      63,    68,    70,    71,    73,    74,    76,    78,    80,    82,
      84,    85,    88,    90,    92,    94,    96,   101,   103,   105,
     107,   109,   113,   115,   117,   118,   120,   122,   124,   125,
     130,   131,   133,   134,   139,   144,   146,   147,   149,   151,
     156,   161,   165,   167,   168,   171,   173,   175,   177,   179,
     181,   183,   184,   186,   188,   189,   191,   193,   195,   197,
     199,   201,   202,   204,   206,   208,   210,   212,   214,   218,
     222,   226,   230,   234,   238,   242,   246,   250,   254,   258,
     262,   266,   269,   271,   273,   276,   280,   282,   286,   290,
     293,   295,   297,   299,   301,   303,   304,   306,   307,   309
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const yysigned_char yyrhs[] =
{
      55,     0,    -1,    55,    56,    -1,     1,    -1,    57,    -1,
      53,    -1,    59,    -1,    58,    -1,    72,    -1,    74,    -1,
      88,    15,    -1,    87,    60,   108,    -1,    65,    -1,    61,
      -1,    62,    -1,    63,    -1,    64,    -1,    66,    -1,    67,
      -1,    16,    -1,    17,    -1,    18,    -1,    19,    -1,    20,
      -1,    21,    -1,    22,    -1,    23,    -1,    24,    -1,    25,
      -1,    26,    -1,    70,    71,    68,    69,    -1,    34,    -1,
      -1,    33,    -1,    -1,    31,    -1,    32,    -1,    46,    -1,
      47,    -1,    48,    -1,    -1,    87,    73,    -1,    27,    -1,
      28,    -1,    29,    -1,    30,    -1,    87,    75,   113,   114,
      -1,    82,    -1,    85,    -1,    86,    -1,    35,    -1,    78,
      79,    80,    -1,    46,    -1,    48,    -1,    -1,    37,    -1,
      38,    -1,    39,    -1,    -1,    81,    78,    79,    80,    -1,
      -1,    49,    -1,    -1,    40,    84,    77,    83,    -1,    40,
      77,    83,    84,    -1,    36,    -1,    -1,    76,    -1,   108,
      -1,    41,    84,    77,    83,    -1,    41,    77,    83,    84,
      -1,    42,    83,    84,    -1,    88,    -1,    -1,    89,    90,
      -1,    93,    -1,   101,    -1,    45,    -1,    46,    -1,    47,
      -1,    48,    -1,    -1,    90,    -1,    93,    -1,    -1,    96,
      -1,    97,    -1,    98,    -1,    99,    -1,   100,    -1,    95,
      -1,    -1,   102,    -1,   103,    -1,   104,    -1,   105,    -1,
     107,    -1,   106,    -1,     3,    91,    92,    -1,     4,    91,
      92,    -1,     5,    91,    92,    -1,     6,    91,    92,    -1,
       7,    91,    92,    -1,     8,    91,    94,    -1,    94,    91,
       8,    -1,     9,    91,    94,    -1,    10,    91,    94,    -1,
      11,    91,    94,    -1,    12,    91,    94,    -1,    13,    91,
      94,    -1,    14,    91,    94,    -1,   113,   109,    -1,   110,
      -1,   111,    -1,   115,   112,    -1,   112,   113,   115,    -1,
     115,    -1,   112,    51,    44,    -1,   112,   113,    44,    -1,
      44,    12,    -1,    12,    -1,    44,    -1,    46,    -1,    47,
      -1,    50,    -1,    -1,   115,    -1,    -1,   116,    -1,    43,
      -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short int yyrline[] =
{
       0,   113,   113,   114,   120,   121,   129,   130,   131,   132,
     143,   153,   157,   158,   159,   161,   163,   165,   166,   178,
     186,   194,   202,   210,   211,   212,   213,   221,   222,   223,
     231,   235,   235,   239,   240,   244,   246,   259,   259,   259,
     259,   289,   293,   296,   299,   302,   312,   316,   319,   322,
     327,   331,   335,   335,   335,   339,   339,   339,   339,   343,
     344,   348,   348,   356,   357,   361,   361,   365,   366,   374,
     375,   383,   391,   392,   396,   400,   401,   405,   405,   405,
     405,   405,   410,   414,   415,   419,   420,   421,   422,   423,
     427,   428,   432,   433,   434,   435,   436,   437,   441,   446,
     451,   456,   461,   466,   468,   473,   478,   483,   488,   493,
     498,   511,   515,   516,   520,   521,   522,   526,   527,   528,
     533,   534,   538,   538,   538,   538,   546,   547,   551,   555
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "LIBRO", "PARTE", "TITOLO", "CAPO",
  "SEZIONE", "ARTICOLO", "COMMA", "CAPOVERSO", "LETTERA", "NUMERO",
  "PARAGRAFO", "PERIODO", "COSTITUZIONE", "DECRETO_PRESIDENTE_REPUBBLICA",
  "DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI",
  "DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI",
  "ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI", "LEGGE_COSTITUZIONALE",
  "LEGGE", "DECRETO_LEGGE", "DECRETO_LEGISLATIVO", "REGIO_DECRETO",
  "REGIO_DECRETO_LEGGE", "REGIO_DECRETO_LEGISLATIVO", "CODICE_CIVILE",
  "CODICE_PROCEDURA_CIVILE", "CODICE_PENALE", "CODICE_PROCEDURA_PENALE",
  "LEGGE_REGIONALE", "REGOLAMENTO_REGIONALE", "REGIONE", "PAROLA_REGIONE",
  "UE_NUM", "UE_DEN", "PARLAMENTO", "CONSIGLIO", "COMMISSIONE",
  "DIRETTIVA", "DECISIONE", "REGOLAMENTO", "DATA_GG_MM_AAAA",
  "NUMERO_CARDINALE", "CITATO", "DEL", "DELL", "DELLA", "E", "IN_DATA",
  "BARRA", "PAROLA", "BREAK", "$accept", "documento", "blocco",
  "riferimento", "costituzione", "normativo", "normativoTipo",
  "decretoPresidenteRepubblica", "decretoPresidenteConsiglioMinistri",
  "direttivaPresidenteConsiglioMinistri",
  "ordinanzaPresidenteConsiglioMinistri", "leggeOrdinaria", "regio",
  "regionale", "regioneParola", "regioneNome", "regionaleTipo",
  "regionaleConnettivo", "codice", "codiceTipo", "comunitario",
  "comunitarioTipo", "comunitarioNumero", "comunitarioEmanante",
  "comunitarioConnettivo", "comunitarioOrgano", "comunitarioEmananteAltri",
  "comunitarioAltri", "comunitarioDirettiva", "comunitarioDenominazione",
  "comunitarioEstremi", "comunitarioDecisione", "comunitarioRegolamento",
  "suddivisioneOpz", "suddivisione", "suddivisioni", "connettivoAtto",
  "suddivisioneConnettivo", "suddivisionePartizioneSupArtOpz",
  "suddivisionePartizioneSupArt", "suddivisionePartizioneInfArtOpz",
  "suddivisionePartizioneInfArt", "suddivisioneLibro", "suddivisioneParte",
  "suddivisioneTitolo", "suddivisioneCapo", "suddivisioneSezione",
  "suddivisioneArticolo", "suddivisioneComma", "suddivisioneCapoverso",
  "suddivisioneLettera", "suddivisioneNumero", "suddivisioneParagrafo",
  "suddivisionePeriodo", "estremi", "estremiTipo", "estremiEstesi",
  "estremiAbbreviati", "estremiNumero", "estremiConnettivo", "dataOpz",
  "data", "dataTipo", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short int yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,    54,    55,    55,    56,    56,    57,    57,    57,    57,
      58,    59,    60,    60,    60,    60,    60,    60,    60,    61,
      62,    63,    64,    65,    65,    65,    65,    66,    66,    66,
      67,    68,    68,    69,    69,    70,    70,    71,    71,    71,
      71,    72,    73,    73,    73,    73,    74,    75,    75,    75,
      76,    77,    78,    78,    78,    79,    79,    79,    79,    80,
      80,    81,    81,    82,    82,    83,    83,    84,    84,    85,
      85,    86,    87,    87,    88,    89,    89,    90,    90,    90,
      90,    90,    91,    92,    92,    93,    93,    93,    93,    93,
      94,    94,    95,    95,    95,    95,    95,    95,    96,    97,
      98,    99,   100,   101,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   109,   110,   110,   110,   111,   111,   111,
     112,   112,   113,   113,   113,   113,   114,   114,   115,   116
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     2,     1,     1,     1,     1,     1,     1,     1,
       2,     3,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       4,     1,     0,     1,     0,     1,     1,     1,     1,     1,
       0,     2,     1,     1,     1,     1,     4,     1,     1,     1,
       1,     3,     1,     1,     0,     1,     1,     1,     0,     4,
       0,     1,     0,     4,     4,     1,     0,     1,     1,     4,
       4,     3,     1,     0,     2,     1,     1,     1,     1,     1,
       1,     0,     1,     1,     0,     1,     1,     1,     1,     1,
       1,     0,     1,     1,     1,     1,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     2,     1,     1,     2,     3,     1,     3,     3,     2,
       1,     1,     1,     1,     1,     0,     1,     0,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned char yydefact[] =
{
       0,     3,    73,     1,    81,    81,    81,    81,    81,    81,
      81,    81,    81,    81,    81,    81,     5,     2,     4,     7,
       6,     8,     9,     0,    72,    81,    75,    81,    90,    85,
      86,    87,    88,    89,    76,    92,    93,    94,    95,    97,
      96,    77,    78,    79,    80,    82,    84,    84,    84,    84,
      84,    91,    91,    91,    91,    91,    91,    91,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    42,
      43,    44,    45,    35,    36,    54,    54,    66,   125,    13,
      14,    15,    16,    12,    17,    18,    40,    41,   125,    47,
      48,    49,    10,    74,     0,    98,    83,    99,   100,   101,
     102,   103,   105,   106,   107,   108,   109,   110,    50,    52,
     123,    53,   124,    67,    66,    58,    54,    68,     0,    66,
      54,    65,   125,   122,    11,    37,    38,    39,    32,   127,
     104,   125,    55,    56,    57,    60,    52,    66,   120,   129,
     121,   111,   112,   113,   125,   116,   128,   125,    66,    71,
      31,    34,    46,   126,    64,    61,    51,    54,    63,   119,
       0,     0,   121,   114,    70,    69,    33,    30,    58,   117,
     118,   115,    60,    59
};

/* YYDEFGOTO[NTERM-NUM]. */
static const short int yydefgoto[] =
{
      -1,     2,    17,    18,    19,    20,    78,    79,    80,    81,
      82,    83,    84,    85,   151,   167,    86,   128,    21,    87,
      22,    88,   113,   114,   115,   135,   156,   157,    89,   122,
     116,    90,    91,    23,    24,    25,    45,    46,    95,    96,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,   117,   141,   142,   143,   144,   118,
     152,   145,   146
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -125
static const yysigned_char yypact[] =
{
      22,  -125,     3,  -125,    83,    83,    83,    83,    83,    83,
      83,    83,    83,    83,    83,    83,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,    56,    15,    83,  -125,    83,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,   110,   110,   110,   110,
     110,    80,    80,    80,    80,    80,    80,    80,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,    -7,    -7,     2,    77,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,    13,  -125,    77,  -125,
    -125,  -125,  -125,  -125,    39,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,     2,    81,   -19,  -125,   -10,     2,
     -19,  -125,   -15,  -125,  -125,  -125,  -125,  -125,    18,    11,
    -125,   -15,  -125,  -125,  -125,    73,  -125,     2,  -125,  -125,
      58,  -125,  -125,  -125,   -25,    -8,  -125,   -15,     2,  -125,
    -125,    62,  -125,  -125,  -125,  -125,  -125,   -19,  -125,  -125,
      82,     1,  -125,  -125,  -125,  -125,  -125,  -125,    81,  -125,
    -125,  -125,    73,  -125
};

/* YYPGOTO[NTERM-NUM].  */
static const short int yypgoto[] =
{
    -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,   -58,   -32,   -31,   -36,  -125,  -125,   -95,
     -76,  -125,  -125,  -125,  -125,  -125,   113,    94,    85,   137,
      12,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,  -125,
    -125,  -125,  -125,  -125,    63,  -125,  -125,  -125,    -5,   -87,
    -125,  -124,  -125
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -92
static const short int yytable[] =
{
     120,   129,   138,     3,   138,   153,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,   119,   131,
     108,   123,   110,     1,   147,   112,   160,   136,   108,   111,
      92,   123,   110,   139,   140,   112,   162,   171,   121,   109,
     110,   111,   158,   112,   139,   170,   149,   130,   -91,   -91,
     -91,   -91,   150,   165,   139,   154,    16,   161,   137,   125,
     126,   127,   148,   101,   102,   103,   104,   105,   106,   107,
     159,   164,    58,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    10,
      11,    12,    13,    14,    15,   166,    75,    76,    77,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
     -62,   -62,   -62,     4,     5,     6,     7,     8,   132,   133,
     134,    94,   155,   123,   110,   168,   169,   112,    41,    42,
      43,    44,    97,    98,    99,   100,   173,   172,    93,    26,
     163,   124
};

static const unsigned char yycheck[] =
{
      76,    88,    12,     0,    12,   129,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    76,   114,
      35,    46,    47,     1,   119,    50,    51,    46,    35,    48,
      15,    46,    47,    43,    44,    50,    44,   161,    36,    46,
      47,    48,   137,    50,    43,    44,   122,     8,    45,    46,
      47,    48,    34,   148,    43,   131,    53,   144,   116,    46,
      47,    48,   120,    51,    52,    53,    54,    55,    56,    57,
      12,   147,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,     9,
      10,    11,    12,    13,    14,    33,    40,    41,    42,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      37,    38,    39,     3,     4,     5,     6,     7,    37,    38,
      39,    27,    49,    46,    47,   157,    44,    50,    45,    46,
      47,    48,    47,    48,    49,    50,   172,   168,    25,     2,
     145,    78
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,     1,    55,     0,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    53,    56,    57,    58,
      59,    72,    74,    87,    88,    89,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,    45,    46,    47,    48,    90,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    91,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    40,    41,    42,    60,    61,
      62,    63,    64,    65,    66,    67,    70,    73,    75,    82,
      85,    86,    15,    90,    91,    92,    93,    92,    92,    92,
      92,    94,    94,    94,    94,    94,    94,    94,    35,    46,
      47,    48,    50,    76,    77,    78,    84,   108,   113,    77,
      84,    36,    83,    46,   108,    46,    47,    48,    71,   113,
       8,    83,    37,    38,    39,    79,    46,    77,    12,    43,
      44,   109,   110,   111,   112,   115,   116,    83,    77,    84,
      34,    68,   114,   115,    84,    49,    80,    81,    83,    12,
      51,   113,    44,   112,    84,    83,    33,    69,    78,    44,
      44,   115,    79,    80
};

#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)		\
   ((Current).first_line   = (Rhs)[1].first_line,	\
    (Current).first_column = (Rhs)[1].first_column,	\
    (Current).last_line    = (Rhs)[N].last_line,	\
    (Current).last_column  = (Rhs)[N].last_column)
#endif

/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)

# define YYDSYMPRINT(Args)			\
do {						\
  if (yydebug)					\
    yysymprint Args;				\
} while (0)

# define YYDSYMPRINTF(Title, Token, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Token, Value);	\
      YYFPRINTF (stderr, "\n");					\
    }								\
} while (0)

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_stack_print (short int *bottom, short int *top)
#else
static void
yy_stack_print (bottom, top)
    short int *bottom;
    short int *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (/* Nothing. */; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_reduce_print (int yyrule)
#else
static void
yy_reduce_print (yyrule)
    int yyrule;
#endif
{
  int yyi;
  unsigned int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %u), ",
             yyrule - 1, yylno);
  /* Print the symbols being reduced, and their result.  */
  for (yyi = yyprhs[yyrule]; 0 <= yyrhs[yyi]; yyi++)
    YYFPRINTF (stderr, "%s ", yytname [yyrhs[yyi]]);
  YYFPRINTF (stderr, "-> %s\n", yytname [yyr1[yyrule]]);
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (Rule);		\
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YYDSYMPRINT(Args)
# define YYDSYMPRINTF(Title, Token, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if defined (YYMAXDEPTH) && YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

#endif /* !YYERROR_VERBOSE */



#if YYDEBUG
/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yysymprint (FILE *yyoutput, int yytype, YYSTYPE *yyvaluep)
#else
static void
yysymprint (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (yytype < YYNTOKENS)
    {
      YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
# ifdef YYPRINT
      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
    }
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  switch (yytype)
    {
      default:
        break;
    }
  YYFPRINTF (yyoutput, ")");
}

#endif /* ! YYDEBUG */
/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yydestruct (int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yytype, yyvaluep)
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  switch (yytype)
    {

      default:
        break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM);
# else
int yyparse ();
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM)
# else
int yyparse (YYPARSE_PARAM)
  void *YYPARSE_PARAM;
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  short int yyssa[YYINITDEPTH];
  short int *yyss = yyssa;
  register short int *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;



#define YYPOPSTACK   (yyvsp--, yyssp--)

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* When reducing, the number of symbols on the RHS of the reduced
     rule.  */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;


  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short int *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	short int *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YYDSYMPRINTF ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %s, ", yytname[yytoken]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;


  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 3:
#line 114 "riferimenti.y"
    { urnFree(&urnTmp); urnShift(&urnTmp); 
				// loggerDebug(utilConcatena(2, "GRAM: documento=", $1)); 
				;}
    break;

  case 4:
#line 120 "riferimenti.y"
    { urnMemorizza(urnTmp); urnInit(&urnTmp); ;}
    break;

  case 5:
#line 121 "riferimenti.y"
    { urnFree(&urnTmp); urnShift(&urnTmp);;}
    break;

  case 10:
#line 143 "riferimenti.y"
    { urnTmp.autorita = strdup("stato"); 
	  				urnTmp.provvedimento = strdup("costituzione"); 
	  				urnTmp.data = strdup("1947-12-27"); ;}
    break;

  case 12:
#line 157 "riferimenti.y"
    { urnTmp.autorita = strdup("stato"); ;}
    break;

  case 13:
#line 158 "riferimenti.y"
    { urnTmp.autorita = strdup("presidente.repubblica"); ;}
    break;

  case 14:
#line 160 "riferimenti.y"
    { urnTmp.autorita = strdup("presidente.consiglio.ministri"); ;}
    break;

  case 15:
#line 162 "riferimenti.y"
    { urnTmp.autorita = strdup("presidente.consiglio.ministri"); ;}
    break;

  case 16:
#line 164 "riferimenti.y"
    { urnTmp.autorita = strdup("presidente.consiglio.ministri"); ;}
    break;

  case 17:
#line 165 "riferimenti.y"
    { urnTmp.autorita = strdup("stato"); ;}
    break;

  case 19:
#line 178 "riferimenti.y"
    { urnTmp.provvedimento = strdup("decreto"); ;}
    break;

  case 20:
#line 186 "riferimenti.y"
    { urnTmp.provvedimento = strdup("decreto"); ;}
    break;

  case 21:
#line 194 "riferimenti.y"
    { urnTmp.provvedimento = strdup("direttiva"); ;}
    break;

  case 22:
#line 202 "riferimenti.y"
    { urnTmp.provvedimento = strdup("ordinanza"); ;}
    break;

  case 23:
#line 210 "riferimenti.y"
    { urnTmp.provvedimento = strdup("legge.costituzionale"); ;}
    break;

  case 24:
#line 211 "riferimenti.y"
    { urnTmp.provvedimento = strdup("legge"); ;}
    break;

  case 25:
#line 212 "riferimenti.y"
    { urnTmp.provvedimento = strdup("decreto.legge"); ;}
    break;

  case 26:
#line 213 "riferimenti.y"
    { urnTmp.provvedimento = strdup("decreto.legislativo"); ;}
    break;

  case 27:
#line 221 "riferimenti.y"
    { urnTmp.provvedimento = strdup("regio.decreto"); ;}
    break;

  case 28:
#line 222 "riferimenti.y"
    { urnTmp.provvedimento = strdup("regio.decreto.legge"); ;}
    break;

  case 29:
#line 223 "riferimenti.y"
    { urnTmp.provvedimento = strdup("regio.decreto.legislativo"); ;}
    break;

  case 33:
#line 239 "riferimenti.y"
    { urnTmp.autorita = utilConcatena(2, "regione.", yyvsp[0]); ;}
    break;

  case 34:
#line 240 "riferimenti.y"
    { urnTmp.autorita = utilConcatena(2, "regione.", configGetRegione()); ;}
    break;

  case 35:
#line 244 "riferimenti.y"
    { urnTmp.provvedimento = strdup("legge"); ;}
    break;

  case 36:
#line 246 "riferimenti.y"
    { urnTmp.provvedimento = strdup("regolamento"); ;}
    break;

  case 41:
#line 289 "riferimenti.y"
    { urnTmp.autorita = strdup("stato"); ;}
    break;

  case 42:
#line 293 "riferimenti.y"
    { urnTmp.provvedimento = strdup("codice.civile");
					  			urnTmp.data = strdup("1942-03-16");
					  			urnTmp.numero = strdup("262"); ;}
    break;

  case 43:
#line 296 "riferimenti.y"
    { urnTmp.provvedimento = strdup("codice.procedura.civile"); 
					  					urnTmp.data = strdup("1940-10-28");
					  					urnTmp.numero = strdup("1443"); ;}
    break;

  case 44:
#line 299 "riferimenti.y"
    { urnTmp.provvedimento = strdup("codice.penale"); 
					  			urnTmp.data = strdup("1930-10-19");
					  			urnTmp.numero = strdup("1398"); ;}
    break;

  case 45:
#line 302 "riferimenti.y"
    { urnTmp.provvedimento = strdup("codice.procedura.penale"); 
					  					urnTmp.data = strdup("1988-09-22");
					  					urnTmp.numero = strdup("447"); ;}
    break;

  case 47:
#line 316 "riferimenti.y"
    { urnTmp.autorita = strdup("comunita.europee"); 
					urnTmp.provvedimento = strdup("direttiva"); ;}
    break;

  case 48:
#line 319 "riferimenti.y"
    { urnTmp.autorita = strdup("comunita.europee"); 
					urnTmp.provvedimento = strdup("decisione"); ;}
    break;

  case 49:
#line 322 "riferimenti.y"
    { urnTmp.autorita = strdup("comunita.europee"); 
					urnTmp.provvedimento = strdup("regolamento"); ;}
    break;

  case 50:
#line 327 "riferimenti.y"
    { urnTmp.numero = (char *) yyvsp[0]; ;}
    break;

  case 98:
#line 442 "riferimenti.y"
    { urnTmp.lib = (char *)yyvsp[-2]; ;}
    break;

  case 99:
#line 447 "riferimenti.y"
    { urnTmp.prt = (char *)yyvsp[-2]; ;}
    break;

  case 100:
#line 452 "riferimenti.y"
    { urnTmp.tit = (char *)yyvsp[-2]; ;}
    break;

  case 101:
#line 457 "riferimenti.y"
    { urnTmp.cap = (char *)yyvsp[-2]; ;}
    break;

  case 102:
#line 462 "riferimenti.y"
    { urnTmp.sez = (char *)yyvsp[-2]; ;}
    break;

  case 103:
#line 467 "riferimenti.y"
    { urnTmp.art = (char *)yyvsp[-2]; ;}
    break;

  case 104:
#line 469 "riferimenti.y"
    { urnTmp.art = (char *)yyvsp[0]; ;}
    break;

  case 105:
#line 474 "riferimenti.y"
    { urnTmp.com = (char *)yyvsp[-2]; ;}
    break;

  case 106:
#line 479 "riferimenti.y"
    { urnTmp.com = (char *)yyvsp[-2]; ;}
    break;

  case 107:
#line 484 "riferimenti.y"
    { urnTmp.let = (char *)yyvsp[-2]; ;}
    break;

  case 108:
#line 489 "riferimenti.y"
    { urnTmp.num = (char *)yyvsp[-2]; ;}
    break;

  case 109:
#line 494 "riferimenti.y"
    { urnTmp.prg = (char *)yyvsp[-2]; ;}
    break;

  case 117:
#line 526 "riferimenti.y"
    { urnTmp.data = (char *) yyvsp[0]; ;}
    break;

  case 118:
#line 527 "riferimenti.y"
    { urnTmp.data = (char *) yyvsp[0]; ;}
    break;

  case 119:
#line 528 "riferimenti.y"
    { urnTmp.data = (char *) yyvsp[-1]; urnTmp.numero = (char *) yyvsp[0];;}
    break;

  case 120:
#line 533 "riferimenti.y"
    { urnTmp.numero = (char *) yyvsp[0]; ;}
    break;

  case 121:
#line 534 "riferimenti.y"
    { urnTmp.numero = (char *) yyvsp[0]; ;}
    break;

  case 128:
#line 551 "riferimenti.y"
    { urnTmp.data = (char *) yyvsp[0]; ;}
    break;

  case 129:
#line 555 "riferimenti.y"
    { yyval = yyvsp[0]; ;}
    break;


    }

/* Line 1010 of yacc.c.  */
#line 1587 "riferimenti.tab.c"

  yyvsp -= yylen;
  yyssp -= yylen;


  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (YYPACT_NINF < yyn && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  int yytype = YYTRANSLATE (yychar);
	  const char* yyprefix;
	  char *yymsg;
	  int yyx;

	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  int yyxbegin = yyn < 0 ? -yyn : 0;

	  /* Stay within bounds of both yycheck and yytname.  */
	  int yychecklim = YYLAST - yyn;
	  int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
	  int yycount = 0;

	  yyprefix = ", expecting ";
	  for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      {
		yysize += yystrlen (yyprefix) + yystrlen (yytname [yyx]);
		yycount += 1;
		if (yycount == 5)
		  {
		    yysize = 0;
		    break;
		  }
	      }
	  yysize += (sizeof ("syntax error, unexpected ")
		     + yystrlen (yytname[yytype]));
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "syntax error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[yytype]);

	      if (yycount < 5)
		{
		  yyprefix = ", expecting ";
		  for (yyx = yyxbegin; yyx < yyxend; ++yyx)
		    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
		      {
			yyp = yystpcpy (yyp, yyprefix);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yyprefix = " or ";
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("syntax error; also virtual memory exhausted");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror ("syntax error");
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* If at end of input, pop the error token,
	     then the rest of the stack, then return failure.  */
	  if (yychar == YYEOF)
	     for (;;)
	       {
		 YYPOPSTACK;
		 if (yyssp == yyss)
		   YYABORT;
		 YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
		 yydestruct (yystos[*yyssp], yyvsp);
	       }
        }
      else
	{
	  YYDSYMPRINTF ("Error: discarding", yytoken, &yylval, &yylloc);
	  yydestruct (yytoken, &yylval);
	  yychar = YYEMPTY;

	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

#ifdef __GNUC__
  /* Pacify GCC when the user code never invokes YYERROR and the label
     yyerrorlab therefore never appears in user code.  */
  if (0)
     goto yyerrorlab;
#endif

  yyvsp -= yylen;
  yyssp -= yylen;
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
      yydestruct (yystos[yystate], yyvsp);
      YYPOPSTACK;
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;


  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*----------------------------------------------.
| yyoverflowlab -- parser overflow comes here.  |
`----------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}


#line 558 "riferimenti.y"


