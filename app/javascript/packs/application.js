require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('channels');
require('bootstrap');
require('jquery');
require('../../assets/stylesheets/application.scss');
require('./uploadImage');
import I18n from 'i18n-js';

global.I18n = I18n;
global.$ = jQuery;
