--Cusotm thirdperson command that can be toggled with rn_togglethirdperson or !thirdperson in chat
if SERVER then
    util.AddNetworkString("ToggleThirdPerson")

    hook.Add("PlayerSay", "ThirdPersonCommand", function(ply, text)
        if string.lower(text) == "!thirdperson" then
            net.Start("ToggleThirdPerson")
            net.Send(ply)
            return ""
        end
    end)

    concommand.Add("rn_togglethirdperson", function(ply, cmd, args)
        net.Start("ToggleThirdPerson")
        net.Send(ply)
    end)
else
    local thirdPersonEnabled = false

    net.Receive("ToggleThirdPerson", function()
        thirdPersonEnabled = not thirdPersonEnabled
        if thirdPersonEnabled then
            hook.Add("CalcView", "ThirdPersonView", function(ply, pos, angles, fov)
                local view = {}
                view.origin = pos - (angles:Forward() * 40) + (angles:Up() * 5) + (angles:Right() * 18)
                view.angles = angles
                view.fov = fov
                view.drawviewer = true

                -- Collision detection
                local trace = util.TraceLine({
                    start = pos,
                    endpos = view.origin,
                    filter = ply
                })

                if trace.Hit then
                    view.origin = trace.HitPos + trace.HitNormal * 5
                end

                return view
            end)
        else
            hook.Remove("CalcView", "ThirdPersonView")
        end
    end)
end
