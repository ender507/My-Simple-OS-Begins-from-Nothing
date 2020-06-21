extern void getchar();
extern void putchar();
extern int row ;
extern int col ;
extern void back();
extern void _end();

char _ch = '.';
char str[20] = "abcdefghijklmnopqrst"; 
char off = 0;
int pos = 0;
int num = 0;
int n = 1;

void putNum(){
	n = 1;
	while(num/n)n*=10;
	n/=10;
	while(n){
		_ch = num/n + '0';
		putchar();
		num %= n;
		n /= 10;
	}
}

void getNum(){
	num = 0;
	while(1){
		getchar();		
		if(_ch=='\r'||_ch=='\n')break;
		num *= 10;
		num = num + _ch -'0';
	}
}

void puts(){
	pos = 0;
	while(1){
		_ch = str[pos++];
		if(_ch=='\0')break;		
		putchar();		
	}
	_ch = '\n';
	putchar();
}

void gets(){
	pos = 0;	
	while(1){
		getchar();		
		if(_ch=='\r'||_ch=='\n')break;
		str[pos++] = _ch;
	}
	str[pos] = '\0';
}

