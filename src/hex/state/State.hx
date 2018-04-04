package hex.state;

import hex.di.IContextOwner;
import hex.event.MessageType;
import hex.util.ArrayUtil;
import hex.util.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class State
{
	var _stateName 					: String;

	var _transitions				= new Map<String,Transition>();

	var _enterHandlers 				: Array<State->Void> = [];
	var _exitHandlers 				: Array<State->Void> = [];

	public function new( stateName : String )
	{
		this._stateName = stateName;
	}
	
	inline public function getName() : String
	{
		return this._stateName;
	}

	public function clearEnterHandler() : Void
	{
		this._enterHandlers = [];
	}

	public function clearExitHandler() : Void
	{
		this._exitHandlers = [];
	}

	public function getEnterHandlerList() : Array<State->Void>
	{
		return this._enterHandlers;
	}

	public function getExitHandlerList() : Array<State->Void>
	{
		return this._exitHandlers;
	}
	
	public function addEnterHandler( callback : State->Void ) : Bool
	{
		return this._addHandler( this._enterHandlers, callback );
	}

	public function addExitHandler( callback : State->Void ) : Bool
	{
		return this._addHandler( this._exitHandlers, callback );
	}

	public function removeEnterHandler( callback: State->Void ) : Bool
	{
		return this._removeHandler( this._enterHandlers, callback );
	}

	public function removeExitHandler( callback: State->Void ) : Bool
	{
		return this._removeHandler( this._exitHandlers, callback );
	}

	public function addTransition( messageType : MessageType, targetState : State ) : Void
	{
		this._transitions.set( messageType, new Transition( this, messageType, targetState ) );
	}

	public function getEvents() : Array<MessageType>
	{
		var transitions : Array<Transition> = this.getTransitions();
		var result : Array<MessageType> 	= [];

		for ( transition in transitions )
		{
			result[ result.length ] = transition.getMessageType();
		}

		return result;
	}

	public function getAllTargets() : Array<State>
	{
		var transitions : Array<Transition> = this.getTransitions();
		var result : Array<State> 	= [];

		for ( transition in transitions )
		{
			result.push( transition.getTarget() );
		}

		return result;
	}

	public function getTransitions() : Array<Transition>
	{
		var i = this._transitions.iterator();
		var a = [];
		while ( i.hasNext() ) a.push( i.next() );
		return a;
	}

	public function hasTransition( messageType : MessageType ) : Bool
	{
		return this._transitions.exists( messageType );
	}

	public function targetState( messageType : MessageType ) : State
	{
		return this._transitions.get( messageType ).getTarget();
	}

	public function toString() : String
	{
		return Stringifier.stringify( this ) + "::" + this._stateName;
	}

	inline function _addHandler( handlers : Array<State->Void>, callback : State->Void ) : Bool
	{
		if ( ArrayUtil.indexOf( handlers, callback ) == -1 )
		{
			handlers.push( callback );
			return true;
		}
		else
		{
			return false;
		}
	}

	inline function _removeHandler( handlers : Array<State->Void>, callback : State->Void ) : Bool
	{
		var id : Int = ArrayUtil.indexOf( handlers, callback );
		if (  id != -1 )
		{
			handlers.splice( id, 1 );
			return true;
		}
		else
		{
			return false;
		}
	}
}