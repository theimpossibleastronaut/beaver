package builder.action;

interface IBuilderAction
{

    function getTypeIdentifier():String;
    function isSuitableActionFor( mySourcePath:String ):Bool;
    function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool;

}