extern void _start();
extern void getChar();
extern void putChar();
extern void backspace();
extern void cmdStr();
extern void errorCmd();
extern void cls();
extern void load();
extern void go();
extern void _end();

char _ch = 'a';		//yao shu chu de zi fu
int row = 0;		// shuchu de hanghao
int col = 0;		// shuchu
char cmd[10] = "0123456789";
char str1[20]="Please Enter Command";
char str2[14]="Wrong Command!";
char str3[29]="Try 'run a','cls'or'run test'";
char str4[17]="program not exit!";
int userPro = 0;
int proSize = 1;
int _es, _ds, _di, _si, _bp, _sp, _dx, _cx, _bx, _ax, _ss;
void printHint(int choice);

void decode(){
	if(cmd[0]=='r'&&cmd[1]=='u'&&cmd[2]=='n'&&cmd[3]==' '){
		cls();
		if(cmd[4]=='a')userPro = 7;
		else if(cmd[4]=='b')userPro = 8;
		else if(cmd[4]=='c')userPro = 9;
		else if(cmd[4]=='d')userPro = 10;
		else if(cmd[4]=='t'&&cmd[5]=='e'&&cmd[6]=='s'&&cmd[7]=='t'){
			if(cmd[8]=='1')userPro = 11;
			else if(cmd[8]=='2'){
				userPro = 12;
				proSize = 2;
			}
		}
		else userPro = 0;
		if(userPro == 0){
			printHint(3);
			return;
		}
		load();
		userPro = 0;
		proSize = 1;
	}
	else if(cmd[0]=='c'&&cmd[1]=='l'&&cmd[2]=='s')cls();
	else {
		cls();
		printHint(2);
	}
}

void getCmd(){
	row = 1;
	col = 0;
	_ch = 'a';
	for(int i=0; i<10; i++)cmd[i] = ' ';
	getChar();
	while(_ch != 13){
		if(_ch == 8){
			_ch = ' ';
			col--;
			putChar();		
		}
		else{
			putChar();
			cmd[col++]=_ch;
		}
		getChar();
	}
	decode();
	return;
}

void printHint(int choice){
	if(choice == 2){
		row = 2;
		for(col=0;col<14;col++){
			_ch = str2[col];
			putChar();
		}
		row = 3;
		for(col=0;col<29;col++){
			_ch = str3[col];
			putChar();
		}
	}
	if(choice == 3){
		row = 2;
		for(col=0;col<17;col++){
			_ch = str4[col];
			putChar();
		}
	}
			row = 0;
	for(col=0;col<20;col++){
		_ch = str1[col];
		putChar();
	}
	getCmd();
}

void cmain(){
	printHint(1);
	cmain();
}
