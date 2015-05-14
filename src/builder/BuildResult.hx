package builder;

class BuildResult {

    /* Ex: HTML, JS, COPY */
    public var buildType:String;

    public var originalSize:Int;
    public var optimizedSize:Int;
    public var sourcePath:String;
    public var destinationPath:String;

    public var success:Bool = false;

    public function new() {}


}