package builder;

import haxe.Json;

class Configuration {

    /**
     * File names / patterns to ignore when building
     */
    public var ignoreFilesOnBuild:Array<String>;

    /* Init new configuration with sane defaults */
    public function new() {

        this.ignoreFilesOnBuild = new Array<String>();
        this.ignoreFilesOnBuild.push(".DS_Store");
        this.ignoreFilesOnBuild.push("desktop.ini");
        this.ignoreFilesOnBuild.push("Thumbs.db");

    }

    public function fromConfigurationString( myConfiguration:String ):Void {

        var data:Dynamic = Json.parse( myConfiguration );

        if ( data.ignoreFilesOnBuild != null ) {
            this.ignoreFilesOnBuild = data.ignoreFilesOnBuild;
        }

    }

    public function toConfigurationString():String {

        return Json.stringify(this, null, "\t");

    }

}