/*-----Seción de declaraciones-------*/
%{
	#include<stdio.h>
	int get,post,options=0;
	int code1,code2,code3,code4,code5=0;
	int moz,chro,ope,saf=0;
	int tamTotalProces=0;
%}
palabra [^ \n<>".]*
cualquier [a-z]*|[0-9]*|\/|"."|\_
ht  "html"
tipo "zip"|"php"|"php"[^ \n<>"]*|{ht}|"gif"|"jpeg"|"png"|"ico"|"xml"|"css"|"jsp"|"js"|"tgz"|"zip"|"gz"|"tar.gz"
horar [0-9][0-9][0-9][0-9]
cifras  [0-9]|[0-9][0-9]|[0-9][0-9][0-9]
h	{cifras}"."{cifras}"."{cifras}"."{cifras}
u 	[a-zA-Z]*
t	[0-3][0-9]\/[A-Z][a-z][a-z]\/[0-2][0-1][0-3][0-9]\:[0-2][0-9]\:[0-6][0-9]\:[0-6][0-9]
m "GET"|"POST"|"OPTIONS"
carpetas \/{palabra}
extension \.{tipo}
r {carpetas}+{extension}|{carpetas}+\/{carpetas}|{carpetas}+\/
inf   [1][0][0-1]
succ  [2][0][0-6]
redir [3][0][0-7]
cerr  [4][0-1][0-9]
codigo ({inf}|{succ}|{redir}|{cerr})" "{cifras}|({inf}|{succ}|{redir}|{cerr})" "\-
num [1]\.[0-1]
uso {ht}\/{num}
servidor "http"\:\/\/{cualquier}*|\"\-\"
navegador [mM]"ozilla"|[cC]"hrome"|[sS]"afari"|[oO]"pera"

%%
	/*-----Sección de Reglas-------*/
{h}   { fprintf(yyout,"<tr><td>%s</td> ",yytext); }
{t}		{ fprintf(yyout,"<td>%s</td>",yytext); }
{m} {
			if(yytext[0]=='G'){
				fprintf(yyout,"<td bgColor='red'>%s</td>",yytext);
				get++;}
			if(yytext[0]=='P'){
					fprintf(yyout,"<td bgColor='blue'>%s</td>",yytext);
					post++;}
			if(yytext[0]=='O'){
				fprintf(yyout,"<td bgColor=#E0E0E0>%s</td>",yytext);
				options++;}
			}
{r}|"/ " {fprintf(yyout,"<td>%s</td>",yytext);}
{codigo}  {
						fprintf(yyout,"<td bgColor=#d9a606>%s</td>",yytext+4);
						yyless(yyleng-3);
						if(yytext[0]=='1'){
						fprintf(yyout,"<td bgColor=#7fffd4>%s</td>",yytext);
						code1++;}
						if(yytext[0]=='2'){
						fprintf(yyout,"<td bgColor=#000099>%s</td>",yytext);
						code2++;}
						if(yytext[0]=='3'){
						fprintf(yyout,"<td bgColor=#925cd8>%s</td>",yytext);
						code3++;}
						if(yytext[0]=='4'){
						fprintf(yyout,"<td bgColor=#990000>%s</td>",yytext);
						code4++;}
						if(yytext[0]=='5'){
						fprintf(yyout,"<td bgColor=#f30806>%s</td>",yytext);
						code5++;}


						}
{servidor} {
						if(yytext[1]=='-')
							fprintf(yyout,"<td>No servidor</td>");
						else{
							fprintf(yyout,"<td>%s</td>",yytext);}
							}
{navegador}	{

					if(yytext[0]=='M'||yytext[0]=='m'){
						fprintf(yyout,"<td bgColor=#ef882e>%s</td></tr>",yytext);
						moz++;}
					if(yytext[0]=='C'||yytext[0]=='c'){
						fprintf(yyout,"<td bgColor=#0dbb72>%s</td></tr>",yytext);
						chro++;}
					if(yytext[0]=='S'||yytext[0]=='s'){
						fprintf(yyout,"<td bgColor=#088da5>%s</td></tr>",yytext);
						saf++;}
					if(yytext[0]=='O'||yytext[0]=='o'){
						fprintf(yyout,"<td bgColor=#f30806>%s</td></tr>",yytext);
						ope++;}
					}
.|\n			{}
%%
/*-----Seción de Procedimientos-------*/

int main (int argc,char *argv[]){

	if(argc==2){
		yyin=fopen(argv[1],"rt");
		if(yyin==NULL){
			printf("El fichero %s no se puede abrir\n",argv[1]);
			exit(-1);
	}
	}
	else yyin=stdin;
  yyout= fopen("index.html","w");

  fprintf(yyout, "<html>\n" );
  fprintf(yyout, "<head>\n" );
  fprintf(yyout, "</head>\n" );
  fprintf(yyout, "<body>\n" );
  fprintf(yyout, "<h1>Logs apache mas detallado</h1>");
	fprintf(yyout, "<a href=\"resumenes.html\">Resumen</a>");
  fprintf(yyout, "<table><tr><td><strong>Ip</strong></td>");
  fprintf(yyout, "<td><strong>Fecha</strong></td>");
  fprintf(yyout, "<td><strong>Tipo</strong></td>");
  fprintf(yyout, "<td><strong>Recurso</strong></td>");
  fprintf(yyout, "<td><strong>Tam.</strong></td>");
	fprintf(yyout, "<td><strong>Code</strong></td>");
  fprintf(yyout, "<td><strong>Servidor</strong></td>");
	fprintf(yyout, "<td><strong>Navegador</strong></td></tr>");
  yylex();
  fprintf(yyout, "</table>");
  fprintf(yyout, "</body>\n" );
	fprintf(yyout, "</html>\n" );



  fclose(yyout);
	yyout= fopen("resumenes.html","w");
	fprintf(yyout, "<html>\n" );
	fprintf(yyout, "<head>\n" );
	fprintf(yyout, "</head>\n" );
	fprintf(yyout, "<body>\n" );
	fprintf(yyout, "<h1>Navegadores mas usados</h1>");
	fprintf(yyout, "<table><tr><td><strong>Mozilla</strong></td>");
	fprintf(yyout, "<td><strong>Chrome</strong></td>");
	fprintf(yyout, "<td><strong>Safari</strong></td>");
	fprintf(yyout, "<td><strong>Opera</strong></td></tr>");
	fprintf(yyout, "<tr><td>%i</td>",moz);
	fprintf(yyout, "<td>%i</td>",chro);
	fprintf(yyout, "<td>%i</td>",saf);
	fprintf(yyout, "<td>%i</td></tr></table>",ope);


	fprintf(yyout, "<h1>Tipos de peticiones</h1>");
	fprintf(yyout, "<table><tr><td><strong>Gets</strong></td>");
	fprintf(yyout, "<td><strong>Post</strong></td>");
	fprintf(yyout, "<td><strong>Options</strong></td>");
	fprintf(yyout, "<tr><td>%i</td>",get);
	fprintf(yyout, "<td>%i</td>",post);
	fprintf(yyout, "<td>%i</td></tr></table>",options);

	fprintf(yyout, "<h1>Codigos de estado</h1>");
	fprintf(yyout, "<table><tr><td><strong>100</strong></td>");
	fprintf(yyout, "<td><strong>200</strong></td>");
	fprintf(yyout, "<td><strong>300</strong></td>");
	fprintf(yyout, "<td><strong>400</strong></td>");
	fprintf(yyout, "<td><strong>500</strong></td></tr>");
	fprintf(yyout, "<tr><td>%i</td>",code1);
	fprintf(yyout, "<td>%i</td>",code2);
	fprintf(yyout, "<td>%i</td>",code3);
	fprintf(yyout, "<td>%i</td>",code4);
	fprintf(yyout, "<td>%i</td></tr>",code5);

  fprintf(yyout, "</body>\n" );
  fprintf(yyout, "</html>\n" );



  fclose(yyin);
  fclose(yyout);

	return 0;
}
