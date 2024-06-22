
RegisterCommand('lagxac', function(source, args, user)
  ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
    if isDead then
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    if delay == 0 then
      delay = 5
    end
    --ApplyForceToEntity(ped, 1, 0.0, 0.0, 500.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
    --chiều ngang - chiều cao
    -- ngang 1000
    -- cao 1000
    --nếu thấy bay lên mà ra xa quá thì chỉnh ngang = 0.0
    else
      notification('Khi Chết Bạn Mới Được Fix Lag Xác')
    end
  end)															
end)