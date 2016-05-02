TOOL.Category 		= "Construction"
TOOL.Name 			= "#Gravity Editor"
TOOL.Command		= nil
TOOL.ConfigName		= nil

if CLIENT then
language.Add("tool.gravityeditor.name", "Gravity Editor")
language.Add("tool.gravityeditor.desc", "Changes the gravity of props!")
language.Add("tool.gravityeditor.0", "Left click a prop to remove its gravity, or right click to restore.")
language.Add("tool.gravityeditor.warning", "WARNING - The boxes below affect ALL props on the map instead of just the selected prop.")
language.Add("tool.gravityeditor.freeze_grav_remove", "Freeze props when gravity is removed")
language.Add("tool.gravityeditor.freeze_grav_restore", "Freeze props when gravity is restored")
language.Add("tool.gravityeditor.freeze_grav_restore.help", "These options also affect the 'apply to ALL' buttons. You can unfreeze them with the Physics Gun, useful for stopping props with no gravity falling back to earth when gravity is given back.")
language.Add("tool.gravityeditor.unfreeze", "Unfreeze mode (both clicks only unfreeze)")
language.Add("tool.gravityeditor.unfreeze.help", "Does not change the gravity of props.")
language.Add("tool.gravityeditor.multibone", "Apply to all bones of prop instead of just one bone")
language.Add("tool.gravityeditor.multibone.help", "Useful for ragdolls, to stop clicking on every limb.")
language.Add("tool.gravityeditor.legacy", "Legacy Mode")
language.Add("tool.gravityeditor.legacy.help", "Good for space fights, where new entities (such as ragdolls) are spawned frequently and you don't need to undo gravity individually or save dupes (unsupported by this mode).")
language.Add("tool.gravityeditor.allfloat", "Take gravity away from ALL valid props")
language.Add("tool.gravityeditor.alldrop", "Give back gravity to ALL valid props")
language.Add("tool.gravityeditor.allfreeze", "Freeze ALL valid props")
language.Add("tool.gravityeditor.allunfreeze", "Unfreeze ALL valid props")
language.Add("tool.gravityeditor.playergrav", "Player + NPC gravity : ")
language.Add("tool.gravityeditor.timescale", "Gravity timescale : ")
language.Add("tool.gravityeditor.adminhidden", "The options here to affect ALL entities are hidden as you are not an administrator.")
end

TOOL.ClientConVar[ "freeze_grav_remove" ] = "0"
TOOL.ClientConVar[ "freeze_grav_restore" ] = "0"
TOOL.ClientConVar[ "unfreeze" ] = "0"
TOOL.ClientConVar[ "multibone" ] = "1"
TOOL.ClientConVar[ "legacy" ] = "0"

concommand.Add( "gravityeditor_allfloat", function( ply )
		if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "Moderator" ) then
		local legacy = tobool( ply:GetInfoNum( "gravityeditor_legacy", 0 ) )
		local freeze_remove = tobool( ply:GetInfoNum( "gravityeditor_freeze_grav_remove", 0 ) )
			if legacy then
				local props = ents.FindByClass("prop_*")
				physenv.SetGravity(Vector(0,0,0))
				for k, v in pairs(props) do
					if(v:GetPhysicsObject():IsValid()) then
						for i=0,v:GetPhysicsObjectCount()-1 do
						v:GetPhysicsObjectNum(i):EnableGravity(true)
						v:SetNWBool( "gravity_disabled", true )
						if freeze_remove then
						v:GetPhysicsObjectNum(i):EnableMotion(false)
						else
						v:GetPhysicsObjectNum(i):Wake()
						end
						end
					end
				end
			else
		local props = ents.FindByClass("prop_*")
		physenv.SetGravity(Vector(0,0,-600))
		for k, v in pairs(props) do
			if(v:GetPhysicsObject():IsValid()) then
				for i=0,v:GetPhysicsObjectCount()-1 do
				v:GetPhysicsObjectNum(i):EnableGravity(false)
				v:SetNWBool( "gravity_disabled", true )
						if freeze_remove then
						v:GetPhysicsObjectNum(i):EnableMotion(false)
						else
						v:GetPhysicsObjectNum(i):Wake()
					end
				end
			end
		end
	end
	else
	//ply:SendLua( [[chat.AddText(Color(255,0,0,255),"Sorry, only admins can take gravity from all props!")]] )
	ply:SendLua( [[notification.AddLegacy( "Sorry, only admins can take gravity from all props!",1,2)]] )
	ply:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )
	end
end)

concommand.Add( "gravityeditor_alldrop", function( ply )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "Moderator" ) then
	local props = ents.FindByClass("prop_*")
	local freeze_restore = tobool( ply:GetInfoNum( "gravityeditor_freeze_grav_restore", 0 ) )
	physenv.SetGravity(Vector(0,0,-600))
		for k, v in pairs(props) do
		if(v:GetPhysicsObject():IsValid()) then				
			for i=0,v:GetPhysicsObjectCount()-1 do
			v:GetPhysicsObjectNum(i):EnableGravity(true)
			v:SetNWBool( "gravity_disabled", false )
				if freeze_restore then
				v:GetPhysicsObjectNum(i):EnableMotion(false)
				else
				v:GetPhysicsObjectNum(i):Wake()
				end
			end
		end
	end
	else
	//ply:SendLua( [[chat.AddText(Color(255,0,0,255),"Sorry, only admins can give gravity back to all props!")]] )
	ply:SendLua( [[notification.AddLegacy( "Sorry, only admins can give gravity back to all props!",1,2)]] )
	ply:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )
	end
end)

concommand.Add( "gravityeditor_allfreeze", function( ply )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "Moderator" ) then
	local props = ents.FindByClass("prop_*")
		for k, v in pairs(props) do
			if(v:GetPhysicsObject():IsValid()) then
				for i=0,v:GetPhysicsObjectCount()-1 do
				v:GetPhysicsObjectNum(i):EnableMotion(false)
				v:GetPhysicsObjectNum(i):Wake()
			end
		end
	end
	else
	//ply:SendLua( [[chat.AddText(Color(255,0,0,255),"Sorry, only admins can make all props freeze!")]] )
	ply:SendLua( [[notification.AddLegacy( "Sorry, only admins can make all props freeze!",1,2)]] )
	ply:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )
	end
end)

concommand.Add( "gravityeditor_allunfreeze", function( ply )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "Moderator" ) then
	local props = ents.FindByClass("prop_*")
		for k, v in pairs(props) do
			if(v:GetPhysicsObject():IsValid()) then
				for i=0,v:GetPhysicsObjectCount()-1 do
				v:GetPhysicsObjectNum(i):EnableMotion(true)
				v:GetPhysicsObjectNum(i):Wake()
			end
		end
	end
	else
	//ply:SendLua( [[chat.AddText(Color(255,0,0,255),"Sorry, only admins can make all props unfreeze!")]] )
	ply:SendLua( [[notification.AddLegacy( "Sorry, only admins can make all props unfreeze!",1,2)]] )
	ply:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )
	end
end)

function TOOL:LeftClick( trace )
	//Gets and changes the tool's user-defined vars into a simple true-or-false
	local freeze_remove = tobool( self:GetClientNumber( "freeze_grav_remove" ) )
	local unfreeze = tobool( self:GetClientNumber( "unfreeze" ) )
	local multibone = tobool( self:GetClientNumber( "multibone" ) )
	if ( !IsValid( trace.Entity ) ) then return false end
	if ( trace.Entity:IsPlayer() || trace.Entity:IsWorld() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end //Client isn't needed
	local ent = trace.Entity
	local entobjectcount = ent:GetPhysicsObjectCount()
	local entphysobj = ent:GetPhysicsObject()
		if unfreeze then
			if multibone then
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableMotion(true)
			ent:GetPhysicsObjectNum(i):Wake()
			end
			return true
			else
			entphysobj:EnableMotion(true)
			entphysobj:Wake()
		end
		return true
	else
		if not multibone then
			entphysobj:EnableGravity(false)
			else
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableGravity(false)
			ent:SetNWBool( "gravity_disabled", true )
			end
		end

	if not freeze_remove then
	
			entphysobj:Wake()
			return true

				else
			
			if not multibone then
			
			entphysobj:EnableMotion(false)
			return true
				
			else
				
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableMotion(false)
			ent:GetPhysicsObjectNum(i):Wake()
			end
			return true
			end
		end
	end
end

function TOOL:RightClick( trace )
	//Gets and changes the tool's user-defined vars into a simple true-or-false
	local freeze_restore = tobool( self:GetClientNumber( "freeze_grav_restore" ) )
	local unfreeze = tobool( self:GetClientNumber( "unfreeze" ) )
	local multibone = tobool( self:GetClientNumber( "multibone" ) )
	if ( !IsValid( trace.Entity ) ) then return false end
	if ( trace.Entity:IsPlayer() || trace.Entity:IsWorld() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end //Client isn't needed
	local ent = trace.Entity
	local entobjectcount = ent:GetPhysicsObjectCount()
	local entphysobj = ent:GetPhysicsObject()
		if unfreeze then
			if multibone then
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableMotion(true)
			ent:GetPhysicsObjectNum(i):Wake()
			end
			return true
			else
			entphysobj:EnableMotion(true)
			entphysobj:Wake()
		end
		return true
	else
		if not multibone then
		entphysobj:EnableGravity(true)
			else
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableGravity(true)
			ent:SetNWBool( "gravity_disabled", false )
			end
		end
	
	if not freeze_restore then
	
			entphysobj:Wake()
			return true
	
				else
				
			if not multibone then

			entphysobj:EnableMotion(false)
			return true
			
			else
			
			for i=0,entobjectcount-1 do
			ent:GetPhysicsObjectNum(i):EnableMotion(false)
			ent:GetPhysicsObjectNum(i):Wake()
			end
			return true
			end
		end
	end
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.gravityeditor.name", Description	= "#tool.gravityeditor.desc" } )
	CPanel:AddControl( "Label", { Text = "#tool.gravityeditor.0" } )
	//local logo = vgui.Create( "DImage" )
	//logo:SetImage( "grav_editor/logo.png" )
	//logo:SetSize( 256, 230 )	I don't think it's possible to stop the image getting squashed if the player presses C- KeepAspect seems to stretch it for no reason and SizeToContents just screws up completely.
	//logo:SetKeepAspect()
	//CPanel:AddPanel( logo )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gravityeditor.freeze_grav_remove", Command = "gravityeditor_freeze_grav_remove" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gravityeditor.freeze_grav_restore", Command = "gravityeditor_freeze_grav_restore", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gravityeditor.unfreeze", Command = "gravityeditor_unfreeze", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gravityeditor.multibone", Command = "gravityeditor_multibone", Help = true } )
	//A nice little annoying warning
	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
	local Warning = vgui.Create( "DLabel" )
	Warning:SetText( "#tool.gravityeditor.warning" )
	Warning:SetFont("DermaDefaultBold")
	Warning:SetTextColor( Color(255, 0, 0, 255) )
	Warning:SetWrap( true )
	Warning:SetSize( 256, 50 )
	CPanel:AddPanel( Warning )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gravityeditor.legacy", Command = "gravityeditor_legacy", Help = true } )
	CPanel:AddControl( "Button", { Label = "#tool.gravityeditor.allfloat", Command = "gravityeditor_allfloat" } )
	CPanel:AddControl( "Button", { Label = "#tool.gravityeditor.alldrop", Command = "gravityeditor_alldrop" } )
	CPanel:AddControl( "Button", { Label = "#tool.gravityeditor.allfreeze", Command = "gravityeditor_allfreeze" } )
	CPanel:AddControl( "Button", { Label = "#tool.gravityeditor.allunfreeze", Command = "gravityeditor_allunfreeze" } )
	CPanel:AddControl( "Slider", { Label = "#tool.gravityeditor.playergrav", Type = "Float", Command = "sv_gravity", Min = "0", Max = "600" } )
	CPanel:AddControl( "Slider", { Label = "#tool.gravityeditor.timescale",	Type = "Float", Command = "phys_timescale", Min = "0", Max = "2" } )
	else
	local WarningNotAdmin = vgui.Create( "DLabel" )
	WarningNotAdmin:SetText( "#tool.gravityeditor.adminhidden" )
	WarningNotAdmin:SetFont("Trebuchet24")
	WarningNotAdmin:SetTextColor( Color(170, 170, 170, 255) )
	WarningNotAdmin:SetWrap( true )
	WarningNotAdmin:SetSize( 256, 100 )
	CPanel:AddPanel( WarningNotAdmin )
	end
end
