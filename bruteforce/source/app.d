import std.stdio;
import std.file;
import std.string;
import std.math;
import std.algorithm;

void main(string[] args) {
	if (args.length < 2){
		writeln("error : 引数が足りてません\nUsage:\n\tbruteforce input [output]");
		return;
	}

	try {
		string cipher;
		string result;
		if (exists(args[1])){
			cipher = args[1].readText;
		} else {
			cipher = args[1];
		}
		result = hack_with_brute_force(cipher);
		if (args.length < 3){
			writeln("結果が出力されました");
			writeln(cipher);
			writeln(result);
		} else {
			std.file.write(args[2],cipher);
			writeln("結果が", args[2], "に出力されました");
			writeln(cipher[0..[50, cipher.length].reduce!min].replace("\n", ""));
			writeln(result[0..[50, result.length].reduce!min].replace("\n", ""));
		}
	} catch (Exception e){
		writeln("error : ",e.msg);
		return;
	}
}
string hack_with_brute_force(string cipher){
	immutable string letters = "abcdefghijklmnopqrstuvwxyz";
	for (int key;key < letters.length;key++){

		string result;
		foreach (char c;cipher.toLower()){
			long index = letters.length - letters.find(c).length;
			if (index == letters.length){
				result ~= c;
			} else {
				long rindex = index - key;
				if (rindex < 0){
					rindex += letters.length;
				}
				result ~= letters[rindex];
			}
		}

		writeln("#key ",key," : ",result[0..[50, result.length].reduce!min].replace("\n", ""));
		writeln("解読できましたか? [y/n]");
		if (readln.chomp.toLower == "y"){
			return result;
		}
	}
	writeln("解読に失敗しました");
	return "";
}
