package kha.graphics4;

import haxe.io.Bytes;
import kha.Blob;

class TessellationEvaluationShader {
	public var _shader: Pointer;
	
	public function new(sources: Array<Blob>, files: Array<String>) {
		initShader(sources[0]);
	}
	
	private function initShader(source: Blob): Void {
		_shader = kore_create_tessevalshader(source.bytes.getData(), source.bytes.getData().length); 
	}

	public static function fromSource(source: String): FragmentShader {
		return null;
	}
	
	public function unused(): Void {
		var include: Bytes = Bytes.ofString("");
	}
	
	@:hlNative("std", "kore_create_tessevalshader") static function kore_create_tessevalshader(data: hl.Bytes, length: Int): Pointer { return null; }
}