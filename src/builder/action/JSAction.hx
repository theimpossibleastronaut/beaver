package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import haxmin.Haxmin;

class JSAction implements IBuilderAction
{

    public function new() {}

    public function getTypeIdentifier():String { return "JS"; }

    public function isSuitableActionFor( mySourcePath:String ):Bool {

        var info:Path = new Path( mySourcePath );

        return (
                    info.ext.toLowerCase() == "js"
                );

    }

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool {

        var content:String = File.getContent( sourcePath );

        content = this.optimizeFileContent( content );

        File.saveContent( destinationPath, content );
        return FileSystem.exists( destinationPath );

    }

    private function optimizeFileContent( content:String ):String {

        var tks = Haxmin.parse( content );
        Haxmin.rename( tks, [], false, true );
        content = Haxmin.print( tks );

        return content;

    }


}