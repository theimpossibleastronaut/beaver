package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import cssmin.Cssmin;

import builder.BuildResult;

class CSSAction implements IBuilderAction
{

    public function new() {}

    public function getTypeIdentifier():String { return "CSS"; }

    public function isSuitableActionFor( mySourcePath:String ):Bool {

        var info:Path = new Path( mySourcePath );

        return (
                    info.ext.toLowerCase() == "css"
                );

    }

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):BuildResult {

        var content:String = File.getContent( sourcePath );
        var originalSize:Int = content.length;

        content = this.optimizeFileContent( content );
        var optimizedSize:Int = content.length;

        File.saveContent( destinationPath, content );

        var result:BuildResult = new BuildResult();
        result.buildType = this.getTypeIdentifier();
        result.originalSize = originalSize;
        result.optimizedSize = optimizedSize;
        result.sourcePath = sourcePath;
        result.destinationPath = destinationPath;
        result.success = FileSystem.exists( destinationPath );

        return result;

    }

    private function optimizeFileContent( content:String ):String {

        var min:Cssmin = new Cssmin();
        var tks:String = min.minify( content );

        return tks;

    }


}