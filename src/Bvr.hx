class Bvr
{

    static public function main()
    {
        var app = new Bvr();
    }

    public function new()
    {

        Sys.println( "Beaver - building dams since 2015!\r\n" );

        var args:Array<String> = Sys.args();

        // Todo create an argument processor here. For now focus on first impl.
        if ( args.length >= 1 ) {

            switch ( args[ 0 ] ) {

                case "build":
                    var builder:String;

                    builder = this.createBuilderFor( Sys.getCwd() );
                    this.build( builder );

                case "watch":
                    Sys.println( "To be implemented" );

                case "deploy":
                    Sys.println( "To be implemented" );

                default:
                    this.printHelpMessage();

            }

        } else {

            this.printHelpMessage();

        }

        Sys.exit( 0 );

    }

    private function printHelpMessage() {

        Sys.println( "Usage:" );
        Sys.println( "bvr build\t\t- build the current folder" );
        Sys.println( "bvr watch\t\t- watch and build the current folder" );
        Sys.println( "bvr deploy\t\t- build and if no errors detected, deploy it" );
        Sys.println( "\r\nIf no .beaver.dam is found in the project folder default settings are used." );

    }

    private function createBuilderFor( myBuildPath:String ):String {

        var guid:String = this.getGuid( myBuildPath );

        Sys.println( "Building project in folder '" + myBuildPath + "'" );

        return guid;

    }

    private function build( myBuilderId:String ) {

        Sys.println( "done." );

    }

    private function getGuid( mySeed:String ):String {

       return haxe.crypto.Md5.encode( mySeed );

    }

}