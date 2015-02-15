package builder;

import haxe.crypto.Md5;
import haxe.Timer;
import sys.FileSystem;

import builder.action.IBuilderAction;
import builder.action.CopyAction;

class Project {

    public var path:String;
    public var guid:String;
    public var destination:String;

    private var fileset:Array<String>;
    private var buildActions:Array<Dynamic>;

    public function new( myPath:String ) {

        this.path = FileSystem.fullPath( myPath );
        this.guid = Md5.encode( myPath );

        if ( !FileSystem.isDirectory( this.path ) ) {

            Sys.println( myPath + " isn't a folder." );
            Sys.exit( 1 );

        }

        // hard for now, will become setting
        this.destination = this.path + "/beaver-build";

        buildActions = new Array<Dynamic>();
        buildActions.push( new CopyAction() );

    }

    public function build():Void {

        var startTime:Float = Timer.stamp();
        Sys.println( "Starting build in folder '" + this.path + "'\r\n" );

        if ( !FileSystem.isDirectory( this.destination ) ) {

            FileSystem.createDirectory( this.destination );

        }

        this.fileset = new Array<String>();
        this.updateFileset( this.path );

        for ( file in this.fileset ) {

            var result:Bool = this.buildFile( file, this.path + "/" + file, this.destination + "/" + file );

            if ( !result ) {

                Sys.println( "Failed at building file: " + file );

            } else {

                Sys.println( "OK " + file );

            }

        }

        var endTime:Float = Timer.stamp();
        Sys.println( "\r\nFinished in " + Math.ceil((endTime - startTime) * 1000000) + "ms" );
        Sys.println( "Build complete at '" + this.destination + "'" );

    }

    public function clean():Void {

        Sys.println( "Cleaning folder '" + this.path + "'" );

        if ( FileSystem.isDirectory( this.destination ) ) {

            FileSystem.deleteDirectory( this.destination );
            FileSystem.createDirectory( this.destination );

        }

        Sys.println( "All clean!" );

    }

    private function updateFileset( folder:String ):Void {

        var files:Array<String> = FileSystem.readDirectory( folder );

        for ( file in files ) {

            var fullPath:String = FileSystem.fullPath( folder + "/" + file );

            if ( FileSystem.isDirectory( fullPath ) &&
                 fullPath != this.destination ) {

                this.updateFileset( fullPath );

            } else if ( !FileSystem.isDirectory( fullPath ) ) {

                var relativePath:String = StringTools.replace( fullPath, this.path + "/", "" );
                this.fileset.push( relativePath );

            }

        }

    }

    private function buildFile( relativeFile:String, sourcePath:String, destinationPath:String ):Bool {

        var result:Bool = false;

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
                break;

            }

        }

        return result;

    }

}