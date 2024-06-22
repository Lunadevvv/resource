Config = {}

Config.Core = 'esx' -- qb / esx
Config.EnableCommand = true
Config.Command = 'skill'
Config.SkillTitle = 'Skills'

Config.Skills = {
  ['Mining'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Mining',
     ['icon'] = 'fas fa-helmet-safety',
  },
  ['Lumberjack'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Lumberjack',
     ['icon'] = 'fas fa-tree',
  },
  ['Fishing'] = {
     ["Current"] = 0,
     ["RemoveAmount"] = 0,
     ["Stat"] = 'Fishing',
     ['icon'] = 'fas fa-fish',
  },
  ['Electric'] = {
   ["Current"] = 0,
   ["RemoveAmount"] = 0,
   ["Stat"] = 'Electric',
   ['icon'] = 'fas fa-charging-station',
   },


}

Config.AddExp = {
  id = 'addexpnotif',
  title = 'XP SYSTEM',
  description = '+',
  description2 = 'XP to ',
  position = 'top-right',
  style = {
      backgroundColor = 'green',
      color = 'white',
      ['.description'] = {
        color = 'white'
      }
  },
  icon = 'check',
  iconColor = 'white'
}