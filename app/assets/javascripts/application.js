// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require twitter/bootstrap
//= require_tree .

function GetContact(s){
    $.ajax({
        url :'/contacts/'+jQuery(s).val()+'/ajax_show',
        dataType: 'script',
        success :function(data){
        }
    })
}

function getJobsite(s){
    $.ajax({
        type: 'GET',
        url: '/jobsites/'+ jQuery(s).val() + '/ajax_show',
        dataType: 'script',
        success: function(data){
//            $("#jobsite").html(data);
            window.location.reload(true);
        }
    });
}

function getJobsiteId(s){
    $.ajax({
        url: '/jobsites/'+ jQuery(s).val() + '/get_id',
        dataType: 'script',
        success: function(data){            
            window.location.reload(true);            
        }
    });   
}

$(document).ready(function(){
    $("#close").click(function(){
        $("#comment").fadeOut();
    });
});