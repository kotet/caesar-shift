import std.algorithm;
import std.typecons;
import std.conv;
import std.stdio;
import std.range;
import std.file;
import std.math;
import std.string;

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
		result = hack_with_frequency_analysis(cipher);
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

string hack_with_frequency_analysis(string cipher){
	writeln("分析中...");
	string analysis_result = analysis(cipher);
	writeln("頻度の高い順に ",analysis_result);
	string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	foreach(char ck;analysis_result){
		//"e"がcに変わっていることから鍵を逆算する
		long key = (letters.length - letters.find(ck).length) - 4;
		if (key < 0){
			key += letters.length;
		}
		string result = cipher.decrypt(key);
		writeln("#key ", ck, " (", key, ")"," : ",result[0..[50, result.length].reduce!min].replace("\n", ""));
		writeln("解読できましたか?[y,n]");
		if (readln.chomp.toLower == "y"){
			return result;
		}
	}
	writeln("解読に失敗しました");
	return "";
}

string decrypt(string cipher, long key){
	string letters = "abcdefghijklmnopqrstuvwxyz";

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
	return result;
}

string analysis(string text, string target = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"){
    /*頻度が高い順にtargetがソートされる*/
    int[string] result;
    foreach(char c;target){
        result[to!string(c)] = 0;
    }
    foreach(char c;text){
        if (target.length - target.find(c).length != target.length){
            result[to!string(c)]++;
        }
    }
    auto keys = result.keys;
    auto values = result.values;
    auto zipped = zip(keys,values);
    sort!(_s)(zipped);
    return keys.join;
}
bool _s (Tuple!(string, int) a,Tuple!(string, int) b){
    if (a[1] == b[1]){
        return a[0] < b[0];
    } else {
        return a[1] > b[1];
    }
}
