package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import cssmin.Cssmin;

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

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool {

        var content:String = File.getContent( sourcePath );

        content = this.optimizeFileContent( content );

        File.saveContent( destinationPath, content );
        return FileSystem.exists( destinationPath );

    }

    private function optimizeFileContent( content:String ):String {

        var min:Cssmin = new Cssmin();
        var tks:String = min.minify( content );

        return tks;

    }


}