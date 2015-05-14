package builder.action;

import builder.action.IBuilderAction;
import sys.io.File;
import sys.FileSystem;
import sys.FileStat;
import builder.BuildResult;

class CopyAction implements IBuilderAction
{

    public function new() {}

    public function getTypeIdentifier():String { return "COPY"; }

    public function isSuitableActionFor( mySourcePath:String ):Bool {

        return true;

    }

    public function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):BuildResult {

        File.copy( sourcePath, destinationPath );

        var info:FileStat = FileSystem.stat( sourcePath );

        var result:BuildResult = new BuildResult();
        result.buildType = this.getTypeIdentifier();
        result.originalSize = info.size;
        result.optimizedSize = info.size;
        result.sourcePath = sourcePath;
        result.destinationPath = destinationPath;
        result.success = FileSystem.exists( destinationPath );

        return result;

    }


}