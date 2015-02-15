import builder.Project;

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

                case "init":
                    Sys.println( "To be implemented" );

                case "clean":
                    var builder:Project;

                    builder = new Project( args.length >= 2 ? args[ 1 ] : Sys.getCwd() );
                    builder.clean();

                case "build":
                    var builder:Project;

                    builder = new Project( args.length >= 2 ? args[ 1 ] : Sys.getCwd() );
                    builder.build();

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
        Sys.println( "bvr init <folder>\t\t- write a default .beaver.dam configuration file" );
        Sys.println( "bvr build <folder>\t\t- build the current or given folder" );
        Sys.println( "bvr clean <folder>\t\t- clean the build folder in the current or given folder" );
        Sys.println( "bvr watch <folder>\t\t- watch and build the current or given folder" );
        //Sys.println( "bvr deploy <folder>\t\t- build and if no errors detected, deploy it" );
        Sys.println( "\r\nIf no .beaver.dam is found in the project folder default settings are used." );

    }

}