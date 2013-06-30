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
//= require best_in_place
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
            
        }
    });
}

function getEditJobsite(s, edit){
    $.ajax({
        type: 'GET',
        url: '/jobsites/'+ jQuery(s).val() + '/ajax_show' + "/?edit=" + edit,
        dataType: 'script',
        success: function(data){
        //            $("#jobsite").html(data);

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

function item_edit_form(item_id){
    $.ajax({
        url:"/items/"+item_id+"/edit",
        success:function(data){
            $("#popup_box").show();
            $("#overlay").show();
            $("#popup_body").html(data);
        }
    });
}


function new_item_form(item_id){
    $.ajax({
        url:"/items/new",
        success:function(data){
            $("#popup_box").show();
            $("#overlay").show();
            $("#popup_body").html(data);
        }
    });
}

 
function hide_popup(){

    if(jQuery('#popup_box')){
        jQuery('#popup_body').html("");
        jQuery('#popup_box').hide();
    }
    if(jQuery('#overlay')){
        jQuery('#overlay').hide();
    }
}

function phone_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "customer_phone" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}


function mobile_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "contact_mobile" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}


function business_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "contact_business" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}

$(document).ajaxStart(function(){
    $('#ajax_loader_big_div').show();
});
$(document).ajaxStop(function(){
    $('#ajax_loader_big_div').hide();
});


$(document).ready(function() {
/* Activating Best In Place */
jQuery(".best_in_place").best_in_place()
});