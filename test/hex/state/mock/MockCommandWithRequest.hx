package hex.state.mock;

import hex.di.ISpeedInjectorContainer;
import hex.control.command.BasicCommand;
import hex.control.Request;
import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithRequest extends BasicCommand implements ISpeedInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser;
	
	override public function execute( ?request : Request ) : Void 
	{
		this.logger.log( this.parser.parse( ( cast request ).code ) );
	}
}