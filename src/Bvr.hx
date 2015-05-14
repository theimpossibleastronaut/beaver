import builder.Project;
import util.Color;

class Bvr
{

    static public function main()
    {
        var app = new Bvr();
    }

    public function new()
    {

        Sys.println( Color.FGWhite + "Beaver - building dams since 2015!" + Color.RESET + "\r\n" );

        var args:Array<String> = Sys.args();

        // Todo create an argument processor here. For now focus on first impl.
        if ( args.length >= 1 ) {

            var builder:Project;

            builder = new Project( args.length >= 2 ? args[ 1 ] : Sys.getCwd() );


            switch ( args[ 0 ] ) {

                case "init":
                    builder.newConfiguration();

                case "clean":
                    builder.clean();

                case "build":
                    builder.build();

                case "watch":
                    Sys.println( Color.FGRed + "To be implemented" + Color.RESET );

                case "deploy":
                    Sys.println( Color.FGRed + "To be implemented" + Color.RESET );

                case "test":
                    Sys.println( Color.FGRed + "To be implemented" + Color.RESET );

                default:
                    this.printHelpMessage();

            }

        } else {

            this.printHelpMessage();

        }

        Sys.exit( 0 );

    }

    private function printHelpMessage() {

        Sys.println( Color.FGWhite + "Usage:" );
        Sys.println( "bvr init " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- write a default .beaver.dam configuration file" );
        Sys.println( "bvr build " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- build the current or given folder" );
        Sys.println( "bvr clean " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- clean the build folder in the current or given folder" );
        //Sys.println( "bvr watch " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- watch and build the current or given folder" );
        //Sys.println( "bvr deploy " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- build and if no errors detected, deploy it" );
        //Sys.println( "bvr test " + Color.FGCyan + "<folder>" + Color.FGWhite + "\t- perform unit tests" );
        Sys.println( "\r\nIf no .beaver.dam is found in the project folder default settings are used." + Color.RESET );

    }

}