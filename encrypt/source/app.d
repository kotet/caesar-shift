import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.math;
import std.algorithm;

void main(string[] args)
{
	//引数の確認
	if (args.length < 2){
		writeln("error : 引数が足りてません\nUsage:\n\tencrypt input [output]");
		return;
	}

	try {
		string cipher;
		string plain;
		if (exists(args[1])){
			plain = args[1].readText;
		} else {
			plain = args[1];
		}
		cipher =  encrypt_with_caesar_cipher(plain);
		if (args.length < 3){
			writeln("結果が出力されました");
			writeln(plain);
			writeln(cipher);
		} else {
			std.file.write(args[2],cipher);
			writeln("結果が ", args[2], " に出力されました");
			writeln(plain[0..[50, plain.length].reduce!min].replace("\n",""));
			writeln(cipher[0..[50, cipher.length].reduce!min].replace("\n",""));
		}
	} catch (Exception e){
		writeln("error: ",e.msg);
		 return;
	}


}
string encrypt_with_caesar_cipher (string plain) {
	immutable string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	write("鍵 (整数、0~25): ");
	int key = abs(cast(int)(readln.chomp.to!real) % 26);

	string cipher;
	foreach (char c; plain.toUpper()){
		//アルファベットでない場合、indexにはletters.lengthが入る
		auto index = letters.length - letters.find(c).length;
		if (index == letters.length){
			cipher ~= c;
		} else {
			int cindex = (index + key) % letters.length;
			if (cindex < 0){
				cindex += letters.length;
			}
			cipher ~= letters[cindex];
		}
	}
	return cipher;
}
