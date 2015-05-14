package builder;

import haxe.crypto.Md5;
import haxe.Timer;
import sys.FileSystem;
import sys.io.File;

import builder.action.IBuilderAction;
import builder.action.CopyAction;
import builder.action.HTMLAction;
import builder.action.JSAction;
import builder.action.CSSAction;
import util.Color;

import builder.Configuration;
import builder.BuildResult;

class Project {

    public var path:String;
    public var guid:String;
    public var destination:String;

    private var fileset:Array<String>;
    private var buildActions:Array<Dynamic>;
    private var configuration:Configuration;

    public function new( myPath:String ) {

        this.path = FileSystem.fullPath( myPath );
        this.guid = Md5.encode( myPath );

        if ( !FileSystem.isDirectory( this.path ) ) {

            Sys.println( myPath + " isn't a folder." );
            Sys.exit( 1 );

        }

        if ( FileSystem.exists( this.path + "/.beaver.dam" ) ) {

            this.configuration = new Configuration();
            this.configuration.fromConfigurationString( File.getContent( this.path + "/.beaver.dam" ) );

        }

        // hard for now, will become setting
        this.destination = this.path + "/beaver-build";

        buildActions = new Array<Dynamic>();
        buildActions.push( new HTMLAction() );
        buildActions.push( new JSAction() );
        buildActions.push( new CSSAction() );
        buildActions.push( new CopyAction() );

    }

    public function newConfiguration():Void {

        Sys.println( Color.FGWhite + "Writing .beaver.dam in folder '" + Color.FGCyan + this.path + Color.FGWhite + "'\r\n" + Color.RESET );

        if ( !FileSystem.isDirectory( this.path ) ) {

            Sys.println( Color.FGGreen + "Creating folder '" + Color.FGCyan + this.path + Color.FGWhite + "'\r\n" + Color.RESET );

            FileSystem.createDirectory( this.path );

        }

        var configuration:Configuration = new Configuration();
        File.saveContent( this.path + "/.beaver.dam", configuration.toConfigurationString() );
        this.configuration = configuration;

    }

    public function build():Void {

        var startTime:Float = Timer.stamp();
        Sys.println( Color.FGWhite + "Starting build in folder '" + Color.FGCyan + this.path + Color.FGWhite + "'\r\n" + Color.RESET );

        if ( !FileSystem.isDirectory( this.destination ) ) {

            Sys.println( Color.FGGreen + "Creating folder '" + Color.FGCyan + this.path + Color.FGWhite + "'\r\n" + Color.RESET );

            FileSystem.createDirectory( this.destination );

        }

        this.fileset = new Array<String>();
        this.updateFileset( this.path );
        var totalSourceSize:Int = 0;
        var totalDestinationSize:Int = 0;

        for ( file in this.fileset ) {

            var result:BuildResult = this.buildFile( file, this.path + "/" + file, this.destination + "/" + file );
            totalSourceSize = totalSourceSize + result.originalSize;
            totalDestinationSize = totalDestinationSize + result.optimizedSize;

            if ( !result.success || result.buildType == "" ) {

                Sys.println( Color.FGRed + "Failed at building file: " + Color.FGCyan + file + Color.RESET );

            } else {

                var sizeText:String = "";

                if ( result.originalSize != result.optimizedSize ) {

                    sizeText = " " + Color.FGYellow + Math.floor( ( result.optimizedSize / result.originalSize ) * 100 ) + "%";

                }

                Sys.println( Color.FGGreen + "OK " + Color.FGCyan + file + Color.FGGrey + " [" + result.buildType + "]" + sizeText + Color.RESET );

            }

        }

        var endTime:Float = Timer.stamp();
        var savingPercentage:Int = Math.floor((totalSourceSize / totalDestinationSize) * 100) - 100;
        Sys.println( Color.FGWhite + "\r\nFinished in " + Math.ceil((endTime - startTime) * 1000) + "ms" + Color.RESET );
        Sys.println( Color.FGWhite + "Saved " + savingPercentage + "% (" + Math.floor((totalSourceSize - totalDestinationSize) / 1024) + " kb)" + Color.RESET );
        Sys.println( Color.FGWhite + "\r\nBuild complete at '" + Color.FGCyan + this.destination + Color.FGWhite + "'" + Color.RESET );

    }

    public function clean():Void {

        Sys.println( Color.FGWhite + "Cleaning folder '" + Color.FGCyan + this.path + Color.FGWhite + "'" + Color.RESET );

        if ( FileSystem.isDirectory( this.destination ) ) {

            this.deleteDirectoryRecursive( this.destination );
            FileSystem.createDirectory( this.destination );

        }

        Sys.println( Color.FGGreen + "All clean!"  + Color.RESET );

    }

    private function updateFileset( folder:String ):Void {

        var files:Array<String> = FileSystem.readDirectory( folder );

        for ( file in files ) {

            var fullPath:String = FileSystem.fullPath( folder + "/" + file );

            if ( !Lambda.has( this.configuration.ignoreFilesOnBuild, file ) ) {

                if ( FileSystem.isDirectory( fullPath ) &&
                     fullPath != this.destination ) {

                    this.updateFileset( fullPath );

                } else if ( !FileSystem.isDirectory( fullPath ) ) {

                    var relativePath:String = StringTools.replace( fullPath, this.path + "/", "" );
                    this.fileset.push( relativePath );

                }

            }

        }

    }

    private function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):BuildResult {

        var result:BuildResult;

        for ( builder in this.buildActions ) {

            var builderAction:IBuilderAction = cast( builder, IBuilderAction );

            if ( builderAction.isSuitableActionFor( sourcePath ) ) {

                // Ensure relative folders exist
                if ( relativeFile.indexOf( "/" ) > -1 ) {

                    var dirParts:Array<String> = relativeFile.split( "/" );

                    var i = 0;
                    var dir:String = "";
                    while ( i < dirParts.length - 1 ) {

                        var destDir:String = dir + "/" + dirParts[ i ];

                        if ( !FileSystem.exists( destDir ) || !FileSystem.isDirectory( destDir ) ) {

                            FileSystem.createDirectory( this.destination + destDir );

                        }

                        dir = destDir;
                        i++;

                    }

                }

                result = builderAction.buildFile( relativeFile, sourcePath, destinationPath );
                return result;

                break;

            }

        }

        result = new BuildResult();
        result.buildType = "UNKNOWN";
        result.sourcePath = sourcePath;
        result.destinationPath = destinationPath;

        return result;

    }

    private function deleteDirectoryRecursive( directoryName:String ):Void {

        for ( item in FileSystem.readDirectory( directoryName ) ) {

            var path:String = directoryName + "/" + item;
            if ( FileSystem.isDirectory( path ) ) {

                this.deleteDirectoryRecursive( path );

            } else {

                FileSystem.deleteFile( path );

            }

        }

        if ( FileSystem.exists( directoryName ) && FileSystem.isDirectory( directoryName ) )
        {
            FileSystem.deleteDirectory(directoryName);
        }

    }

}