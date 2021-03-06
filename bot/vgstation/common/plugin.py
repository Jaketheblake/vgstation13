'''
Created on Aug 26, 2012

@author: Rob
'''
# print 'Loading '+__file__
import logging, os, glob

def DefinePlugin():
    registry = {}
    def handler(_class):
        packageID = _class.__module__ + "." + _class.__name__
        registry[packageID] = {
            'name':_class.Name,
            'class':_class
        }
        return _class
    handler.all = registry
    return handler

Plugin = DefinePlugin() 

def Load(bot):
    for f in glob.glob(os.path.join(os.path.curdir,'plugins',"*.py")):
        modName='plugins.'+os.path.basename(f)[:-3]
        logging.info('Loading '+modName)
        mod = __import__(modName)
        for attr in dir(mod):
            if not attr.startswith('_'):
                globals()[attr] = getattr(mod, attr)
    o=[]
    logging.info('Loaded: '+repr(Plugin.all))
    for key in Plugin.all:
        currentHandler = Plugin.all[key]['class']
        o += [currentHandler(bot)]
    return o
    
class IPlugin(object):
    Name = 'Plugin'
    def __init__(self, bot):
        '''
        @param bot: The bot.
        '''
        self.bot=bot
    
    def RegisterCommand(self, command, handler, **kwargs):
        if command in self.bot.command:
            logging.warning('Command {0} cannot be registered twice!'.format(command))
            return
        kwargs['handler']=handler
        self.bot.command[command]=kwargs
        
    def OnChannelMessage(self, connection, event):
        return False # Not handled
        
    def OnPing(self):
        return False # Not handled