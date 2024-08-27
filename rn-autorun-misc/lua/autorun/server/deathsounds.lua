local function InitializeDeathSounds()
    local teamDeathSounds = {}

    if TEAM_CPR then
        teamDeathSounds[TEAM_CPR] = {"npc/metropolice/die2.wav", "npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav", "npc/overwatch/radiovoice/union.wav", "npc/overwatch/radiovoice/one.wav", "npc/overwatch/radiovoice/remainingunitscontain.wav", "npc/overwatch/radiovoice/off2.wav"}
    end

    if TEAM_CPO then
        teamDeathSounds[TEAM_CPO] = {"npc/metropolice/die2.wav", "npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav", "npc/overwatch/radiovoice/union.wav", "npc/overwatch/radiovoice/two.wav", "npc/overwatch/radiovoice/remainingunitscontain.wav", "npc/overwatch/radiovoice/off2.wav"}
    end

    if TEAM_CPTL then
        teamDeathSounds[TEAM_CPTL] = {"npc/metropolice/die2.wav", "npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav", "npc/overwatch/radiovoice/union.wav", "npc/overwatch/radiovoice/three.wav", "npc/overwatch/radiovoice/remainingunitscontain.wav", "npc/overwatch/radiovoice/off2.wav"}
    end

    if TEAM_OTAEO then
        teamDeathSounds[TEAM_OTAEO] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAES then
        teamDeathSounds[TEAM_OTAES] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAMS then
        teamDeathSounds[TEAM_OTAMS] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAEE then
        teamDeathSounds[TEAM_OTAEE] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAME then
        teamDeathSounds[TEAM_OTAME] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAOV then
        teamDeathSounds[TEAM_OTAOV] = {"npc/combine_soldier/die1.wav"}
    end

    if TEAM_OTAOR then
        teamDeathSounds[TEAM_OTAOR] = {"npc/combine_soldier/die1.wav"}
    end

    local function PlayQueuedSounds(ply, sounds, volume)
        if #sounds == 0 then return end

        local sound = table.remove(sounds, 1)
        ply:EmitSound(sound, volume)

        timer.Simple(SoundDuration(sound), function()
            PlayQueuedSounds(ply, sounds, volume)
        end)
    end

    hook.Add("PlayerDeath", "PlayDeathSound", function(victim, inflictor, attacker)
        local sounds = teamDeathSounds[victim:Team()]
        if sounds then
            for _, ply in ipairs(player.GetAll()) do
                local distance = ply:GetPos():Distance(victim:GetPos())
                if distance <= 400 then
                    local volume = math.Clamp(1 - (distance / 400), 0, 1) * 100
                    PlayQueuedSounds(ply, table.Copy(sounds), volume)
                end
            end
        end
    end)

    local function AssignDeathSound(ply)
        local sounds = teamDeathSounds[ply:Team()]
        if sounds then
            ply:SetNWString("DeathSound", sounds[1])
        else
            ply:SetNWString("DeathSound", "")
        end
    end

    hook.Add("PlayerChangedTeam", "UpdateDeathSound", function(ply, oldTeam, newTeam)
        AssignDeathSound(ply)
    end)

    hook.Add("PlayerSpawn", "AssignDeathSoundOnSpawn", function(ply)
        AssignDeathSound(ply)
    end)

    hook.Add("PlayerInitialSpawn", "AssignDeathSoundOnJoin", function(ply)
        AssignDeathSound(ply)
    end)

    hook.Add("Initialize", "AssignDeathSoundsOnServerStart", function()
        for _, ply in ipairs(player.GetAll()) do
            AssignDeathSound(ply)
        end
    end)
end

hook.Add("InitPostEntity", "InitializeDeathSoundsAfterJobs", InitializeDeathSounds)