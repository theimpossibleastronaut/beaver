package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

class HTMLAction implements IBuilderAction
{

    public function new() {}

    public function getTypeIdentifier():String { return "HTML"; }

    public function isSuitableActionFor( mySourcePath:String ):Bool {

        var info:Path = new Path( mySourcePath );

        return (
                    info.ext.toLowerCase() == "html" ||
                    info.ext.toLowerCase() == "htm"
                );

    }

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool {

        var content:String = File.getContent( sourcePath );

        content = this.optimizeFileContent( content );

        File.saveContent( destinationPath, content );
        return FileSystem.exists( destinationPath );

    }

    private function optimizeFileContent( content:String ):String {

        return content;

    }


}