package builder.action;

interface IBuilderAction
{

    function isSuitableActionFor( mySourcePath:String ):Bool;
    function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool;

}