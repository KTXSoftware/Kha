package kha.internal;

import haxe.Json;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

#if macro
import sys.io.File;
#end

using StringTools;

class AssetsBuilder {
	public static function findResources(): String {
		#if macro
		var output = Compiler.getOutput();
		if (output == "Nothing__" || output == "") { // For Haxe background compilation
			#if kha_output
			output = Compiler.getDefine("kha_output");
			if (output.startsWith('"')) {
				output = output.substr(1, output.length - 2);
			}
			#end
		}
		output = output.replace("\\", "/");
		output = output.substring(0, output.lastIndexOf("/"));
		if (output.endsWith("/Assets")) { // For Unity
			output = output.substring(0, output.lastIndexOf("/"));
		}
		if (output.lastIndexOf("/") >= 0) {
			var system = output.substring(output.lastIndexOf("/") + 1);
			if (system.endsWith("-build")) system = system.substr(0, system.length - "-build".length);
			output = output.substring(0, output.lastIndexOf("/"));
			return output + "/" + system + "-resources/";
		}
		else {
			if (output.endsWith("-build")) output = output.substr(0, output.length - "-build".length);
			if (output == "") output = "empty";
			return output + "-resources/";
		}
		#else
		return "";
		#end
	}

	macro static public function build(type: String): Array<Field> {
		var fields = Context.getBuildFields();
		var content = Json.parse(File.getContent(findResources() + "files.json"));
		var files: Iterable<Dynamic> = content.files;

		var names = new Array<Expr>();

		for (file in files) {
			var name = file.name;
			var filename = file.files[0];

			if (file.type == type) {

				names.push(macro $v{name});

				switch (type) {
					case "image":
						fields.push({
							name: name,
							access: [APublic],
							kind: FVar(macro: kha.Image, macro null),
							pos: Context.currentPos()
						});
					case "sound":
						fields.push({
							name: name,
							access: [APublic],
							kind: FVar(macro: kha.Sound, macro null),
							pos: Context.currentPos()
						});
					case "blob":
						fields.push({
							name: name,
							access: [APublic],
							kind: FVar(macro: kha.Blob, macro null),
							pos: Context.currentPos()
						});
					case "font":
						fields.push({
							name: name,
							access: [APublic],
							kind: FVar(macro: kha.Font, macro null),
							pos: Context.currentPos()
						});
					case "video":
						fields.push({
							name: name,
							access: [APublic],
							kind: FVar(macro: kha.Video, macro null),
							pos: Context.currentPos()
						});
				}

				fields.push({
					name: name + "Description",
					doc: null,
					meta: [],
					access: [APublic],
					kind: FVar(macro: Dynamic, macro $v { file }),
					pos: Context.currentPos()
				});
			}
		}

		return fields;
	}
}
