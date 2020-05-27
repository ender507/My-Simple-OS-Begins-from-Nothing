extern void _start();
extern void getChar();
extern void putChar();
extern void cmdStr();
extern void errorCmd();
extern void cls();
extern void load();
extern void go();
extern void _end();

char _ch = 'a';
char cmd[10] = "0123456789";
int pos = 0;
int userPro = 0;
char color = 1;

void decode(){
	if(cmd[0]=='r'&&cmd[1]=='u'&&cmd[2]=='n'){
		cls();
		if(cmd[4]=='a')userPro = 5;
		else if(cmd[4]=='b')userPro = 6;
		else if(cmd[4]=='c')userPro = 7;
		else if(cmd[4]=='d')userPro = 8;
		load();
		userPro = 0;
	}
	else if(cmd[0]=='c'&&cmd[1]=='l'&&cmd[2]=='s')cls();
	else {
		cls();
		errorCmd();
	}
	go();
}

void getCmd(){
	pos = 0;
	_ch = 'a';
	for(int i=0; i<10; i++)cmd[i] = ' ';
	getChar();
	while(_ch != 13){
		if(_ch == 8){
			_ch = ' ';
			pos--;
			putChar();		
		}
		else{
			putChar();
			cmd[pos++]=_ch;
		}
		getChar();
	}
	decode();
}

void cmain(){
	cmdStr();
	getCmd();
	return;
}
