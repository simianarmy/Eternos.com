// CHANGE FOR APPS HOSTED IN SUBDIRECTORY
FCKRelativePath = '';

// CHANGE THESE for custom uploaders
var _FileBrowserLanguage   = 'cfm'; 
var _QuickUploadLanguage   = 'cfm' ;
FCKConfig.LinkBrowserURL = '/contents/new'; //FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.ImageBrowserURL = '/contents/new'; //FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Image&Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.FlashBrowserURL = '/contents/new'; //FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Flash&Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.LinkUpload = false;
FCKConfig.ImageUpload = false;
FCKConfig.FlashUpload = false;

FCKConfig.LinkUploadURL = FCKRelativePath+'/fckeditor/upload';
FCKConfig.ImageUploadURL = FCKRelativePath+'/fckeditor/upload?Type=Image';
FCKConfig.FlashUploadURL = FCKRelativePath+'/fckeditor/upload?Type=Flash';
FCKConfig.SpellerPagesServerScript = FCKRelativePath+'/fckeditor/check_spelling';
FCKConfig.AllowQueryStringDebug = false;
FCKConfig.SpellChecker = 'SpellerPages';

FCKConfig.Plugins.Add( 'easyUpload', 'en' ) ;

FCKConfig.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;

// ONLY CHANGE BELOW HERE
FCKConfig.EditorAreaCSS = '' // '/stylesheets/standard.css' ;

FCKConfig.SkinPath = FCKConfig.BasePath + 'skins/silver/';

FCKConfig.ToolbarSets["Easy"] = [
        ['Bold','Italic','Underline','StrikeThrough','-'],
        ['OrderedList','UnorderedList','-'],
        ['FontSize'], ['TextColor','BGColor'],
        ['easyImage', 'easyLink', 'Unlink']
] ;

FCKConfig.ToolbarSets["Simple"] = [
        ['Source','-','-','Templates'],
        ['Cut','Copy','Paste','PasteWord','-','Print','SpellCheck'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll'],
        '/',
        ['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
        ['OrderedList','UnorderedList','-','Outdent','Indent'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
        ['Link','Unlink'],
        '/',
        ['Image','Table','Rule','Smiley'],
        ['FontName','FontSize'],
        ['TextColor','BGColor'],
        ['-','About']
] ;

FCKConfig.ToolbarSets["RealSimple"] = [
        ['Source','Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
        ['OrderedList','UnorderedList','-'],
        ['Style','FontFormat','FontName', 'FontSize'], ['TextColor','BGColor'],
				['easyLink', 'Unlink','Smiley','SpecialChar','PageBreak','SpellCheck']
] ;

FCKConfig.ToolbarSets["Custom1"] = [
        ['Cut','Copy','Paste','PasteWord','-','Print','SpellCheck'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll'],
        '/',
        ['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
        ['OrderedList','UnorderedList','-','Outdent','Indent'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
        ['Link','Unlink','-','Smiley'],
        '/',
        ['FontName','FontSize'],
        ['TextColor','BGColor']
] ;
