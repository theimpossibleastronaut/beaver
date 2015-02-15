package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;

class CopyAction implements IBuilderAction
{

    public function new() {}

    public function isSuitableActionFor( mySourcePath:String ):Bool {

        return true;

    }

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool {

        File.copy( sourcePath, destinationPath );
        return FileSystem.exists( destinationPath );

    }


}