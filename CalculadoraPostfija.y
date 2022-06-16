%{
    #include <stdio.h>
    #include <math.h>
    #define YYSTYPE int
    void yyerror(char *s);
    int yylex();
    void yywarning(char *s,char *t);
%}

%token NUMBER
%left '+' '-' '*' '/'
%%
    list: /*VACIO*/
        |list '\n'
        |list exp '\n' { printf("r:\t%i\n",$2); }
    ;
    exp: NUMBER {$$=$1;}
        |exp exp '+'{$$=$1+$3;}
        |exp exp '-'{$$=$1-$3;}
        |exp exp '*'{$$=$1*$3;}
        |exp exp '/'{$$=$1/$3;}
        | '(' exp ')'{$$=$2;}
        ;
%%

#include <stdio.h>
#include <ctype.h>
char *progname;
int lineno = 1;

void main(int argc, char *argv[])
{
    //progname = argv[0];
    yyparse();
}
int yylex(){
    int c;
    while((c=getchar())==' '|| c=='\t');
    if(c==EOF) return 0;
    if(isdigit(c)){
        ungetc(c,stdin);
        scanf("%i", &yylval);
    return NUMBER;
    }
    if(c=='\n') lineno++;
    return c;
}
void yyerror(char *s){
    yywarning(s,(char *)0);
}
void yywarning(char *s,char *t){
    fprintf(stderr,"%s: %s",progname,s);
    if(t) fprintf(stderr," %s",t);
    fprintf(stderr," near line %d\n",lineno);
}
