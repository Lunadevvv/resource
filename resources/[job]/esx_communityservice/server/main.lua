ESX.RegisterCommand('hotcuc', 'superadmin', function(xPlayer, args, showError)
	print(args.id)
	if args.id and GetPlayerName(args.id) ~= nil and tonumber(args.number) then
		TriggerEvent('luna:SendToCommunityService', tonumber(args.id), tonumber(args.number))
	else
		showError(_U('invalid_player_id_or_actions'))
	end
end, false, {help = 'hotcuc', validate = false, arguments = {
    {name = 'id', help = ('ID'), type = 'any'},
	{name = 'number', help = ('Number'), type = 'any'}
}})

ESX.RegisterCommand('huyhotcuc', 'user', function(xPlayer, args, showError)
	if args.id then
		if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
			if GetPlayerName(args.id) ~= nil then
				TriggerEvent('luna:endCommunityServiceCommand', tonumber(args.id))
			else
				-- TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id')  } } )
				showError(_U('invalid_player_id'))
			end
		end
	else
		TriggerEvent('luna:endCommunityServiceCommand', source)
	end
end, false, {help = 'banreload', validate = false, arguments = {
    {name = 'id', help = ('ID'), type = 'any'}
}})

RegisterServerEvent('luna:endCommunityServiceCommand')
AddEventHandler('luna:endCommunityServiceCommand', function(source)
	if source ~= nil then
		rhMck9sCCSTtRdH84JvGe1yR2Sqg5tE82E(source)
	end
end)

-- unjail after time served
RegisterServerEvent('luna:finishCommunityService')
AddEventHandler('luna:finishCommunityService', function()
	rhMck9sCCSTtRdH84JvGe1yR2Sqg5tE82E(source)
end)

RegisterServerEvent('luna:completeService')
AddEventHandler('luna:completeService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	MySQL.Async.fetchAll('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		else
			-- print ("luna :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)

RegisterServerEvent('luna:SendToCommunityService')
AddEventHandler('luna:SendToCommunityService', function(target, actions_count)
	local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	if xPlayer.job.name == 'police' then
		MySQL.Async.fetchAll('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@actions_remaining'] = actions_count
				})
			else
				MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining) VALUES (@identifier, @actions_remaining)', {
					['@identifier'] = identifier,
					['@actions_remaining'] = actions_count
				})
			end
		end)

		TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) }, color = { 147, 196, 109 } })
		TriggerClientEvent('esx_policejob:unrestrain', target)
		TriggerClientEvent('luna:inCommunityService', target, actions_count)
	end
end)

RegisterServerEvent('luna:checkIfSentenced')
AddEventHandler('luna:checkIfSentenced', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil and result[1].actions_remaining > 0 then
			--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(_source), ESX.Math.Round(result[1].jail_time / 60)) }, color = { 147, 196, 109 } })
			TriggerClientEvent('luna:inCommunityService', _source, tonumber(result[1].actions_remaining))
		end
	end)
end)

function rhMck9sCCSTtRdH84JvGe1yR2Sqg5tE82E(target)

	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})

			TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_finished', GetPlayerName(target)) }, color = { 147, 196, 109 } })
		end
	end)

	TriggerClientEvent('luna:finishCommunityService', target)
end
