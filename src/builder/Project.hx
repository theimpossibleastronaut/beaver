package builder;

import haxe.crypto.Md5;
import haxe.Timer;
import sys.FileSystem;

class Project {

    public var path:String;
    public var guid:String;
    public var destination:String;

    public function new( myPath:String ) {

        this.path = FileSystem.fullPath( myPath );
        this.guid = Md5.encode( myPath );

        if ( !FileSystem.isDirectory( this.path ) ) {

            Sys.println( myPath + " isn't a folder." );
            Sys.exit( 1 );

        }

        // hard for now, will become setting
        this.destination = this.path + "/beaver-build";

    }

    public function build():Void {

        var startTime:Float = Timer.stamp();
        Sys.println( "Starting build in folder '" + this.path + "'" );

        if ( !FileSystem.isDirectory( this.destination ) ) {

            FileSystem.createDirectory( this.destination );

        }

        var endTime:Float = Timer.stamp();
        Sys.println( "Finished in " + Math.ceil((endTime - startTime) * 1000000) + "ms" );
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

}