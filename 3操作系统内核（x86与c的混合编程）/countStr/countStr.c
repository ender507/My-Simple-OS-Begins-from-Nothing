char ch = 'a';
extern char str[];
char countChar(){
	char tmp = ch;
	char ans = '0';
	for(int i=0; i<21; i++){
		if(tmp==str[i])ans++;
	}
	return ans;
}
