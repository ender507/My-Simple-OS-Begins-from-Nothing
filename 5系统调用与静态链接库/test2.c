#include"libs.h"

void main(){
	getchar();
	char c = _ch;
	_ch = '\n';
	putchar();
	_ch = c;
	putchar();
	_ch = '\n';
	putchar();
	gets();
	char *string = str;
	for(int i=0; string[i-1]!='\0';i++)str[i] = string[i];
	puts();
	getNum();
	int n = num;
	num = n;
	putNum();
	back();
}
