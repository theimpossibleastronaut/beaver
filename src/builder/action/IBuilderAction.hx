package builder.action;

import builder.BuildResult;

interface IBuilderAction
{

    function getTypeIdentifier():String;
    function isSuitableActionFor( mySourcePath:String ):Bool;
    function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):BuildResult;

}