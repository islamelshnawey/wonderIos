import WoWonderTimelineSDK
import Foundation
import UIKit

//Messenger
protocol GenderDelegate {
    func selectGender(text:String,Index:Int)
}

protocol FollowUnFollowDelegate {
    func followUnfollow(user_id:String,index:Int,cellBtn:UIButton)
}
protocol ImagePickerDelegate{
    func pickImage(image:UIImage? , videoData:Data?,videoURL:URL? ,Status:Bool?)
}
protocol PlayVideoDelegate {
    func playVideo(index:Int,status:Bool)
}
protocol PlayAudioDelegate {
    func playAudio(index:Int,status:Bool,url:URL,button:UIButton)
}

protocol SelectFileDelegate {
    func selectImage(status:Bool)
    func selecVideo(status:Bool)
}
protocol SelectContactDetailDelegate {
    func selectContact(key:String,value:String)
}

protocol SelectContactCallsDelegate {
    func selectCalls(index:Int,type:String)
}

protocol SelectRandomDelegate {
    func selectRandom(recipientID:String, searchObject:SearchModel.User)
}
protocol CallReceiveDelegate {
    func receiveCall(callId:Int,RoomId:String,callingType:String,username:String,profileImage:String,accessToken:String?)
}
protocol SelectLanguageDelegate {
    func selectLanguage(index:Int,Button:UIButton)
}

protocol didSelectGIFDelegate {
    func didSelectGIF(GIFUrl:String,id: String)
}

protocol sendLocationProtocol {
    func sendLocation(lat: Double, long: Double)
}

//Timeline
protocol blockUserDelegate {
    func block()
}
protocol FilterBlockUser{
    func filterBlockUser (userId : String)
}
protocol sendImagetoMyProfile{
    func sendImage(image : UIImage,isCover : Int)
}
protocol changeProfilePicDelegate{
    func changePic(image: String)
}
protocol selectCategoryDelegate{
    func selectCategory(categoryID : Int,categoryName : String)
}
protocol CreatePageDelegate {
    func sendPageData(pageData : [String:Any])
}
protocol PageMoreDelegate{
    func gotoSetting(type: String)
}
protocol PageRatingDelegate{
    func pageRating(rating: Double)
}
protocol CreateGroupDelegate {
    func sendGroupData(groupData : [String:Any])
}
protocol GroupMoreDelegate{
    func gotoSetting(type: String)
}
protocol DeleteGroupDelegate {
    func deleteGroup(groupId : String)
}
protocol EditGroupDataDelegate {
    func editGroup(groupName : String, groupTitle : String, about : String, Category : String, CategoryId : String)
}
protocol JoinGroupDelegate{
    func joinGroup(isJoin : Bool)
}
protocol EditProfileDelegate{
    func editProfile(firstName : String, lastName: String, phone : String, webSite : String, WorkPlace : String, School : String, location : String)
}
protocol CallActionDelegate{
    func sendCallAction(callActionId : String, callActionName : String)
}
protocol EditPageDelegete {
    func editPage(pageData : [String:Any])
}
protocol PageLikeDelegate{
    func pageLiked(isLike: Bool)
}
protocol DeletePageDelegate {
    func deletePage (pageId : String)
}
protocol uploadImageDelegate {
   func uploadImage(imageType : String, image : UIImage)
}
protocol JobDataDelegate{
    func sendJobData(jobData : [String:Any])
}

protocol JobCurrencyDelegate{
    func jobCurrency(currency : String, currencyId : String)
}
protocol JobTypeDelegate {
    func jobType(jobType: String, type: String)
}
protocol JobSalaryDelegate{
    func salaryData(salaryDate : String,salaryType : String)
}
protocol JobCategoryDelegate{
    func category(category: String, categoryId: String)
}
protocol EditJobDataDelegate{
    func editJobData(jobData :JobDetails)
}
protocol EditJobDelegate {
    func editJob()
}
protocol DeleteJobDelegate{
    func deleteJob(jobId : Int)
}
protocol CreateAlbumDelegate {
    func createAlbum(data:[String:Any])
}
protocol BlogCategoryDelegate{
    func blogCategory(categoryName :String, categoryId :Int)
}
protocol CreateProductDelegate {
    func createProduct()
}
protocol ProductCategoryDelegate {
    func category(categoryName :String, categoryId :String)
}
protocol ProductDistanceDelegate{ 
    func productDistance(distance :Int)
}
protocol CreateEventDelegate{
    func createEvent(eventId :Int)
}
protocol GoingEventDelegate {
    func goingEvent(isGoing :Bool)
}
protocol InterestedEventDelegate{
    func interestedEvent(isInterested :Bool)
}
protocol JobFilterDelegate{
    func jobFilter(categoryId: String,jobType: String,distance: Int)
}
protocol AddReactionDelegate{
   func addReaction(reation: String)
}
protocol SharePostDelegate{
    func sharePost()
    func sharePostTo(type: String)
    func sharePostLink()
    func selectPageandGroup(data:[String:Any],type: String)    
}
protocol SearchDelegate{
    func locationSearch(location: String, countryId: String)
    func filterSearch(gender: String, countryId: String, ageTo: String, ageFrom: String, verified: String, status: String, profilePic: String)
}
protocol MoveControllerDelegate {
    func moveController()
}
protocol ProfileMoreDelegate{
    func profileMore(tag: Int)
}
protocol selecteUSerDelegate {
    func selectUser(name: String,user_id: String)
}
protocol didSelectPostType {
    func didselectPostType(type:String,feelingType:String?,FeelingTypeString:String?)
}
protocol didGetFundingAmountDelegate{
    func didGetFundingAmount(amount:String,index:Int)
}
protocol didSelectPaymentTypeDelegate{
    func didSelectPaymentType(typeString:String,index:Int)
}
protocol block_unblockDelegate {
    func unblock(user_id: String)
}
protocol filterFriendsDelegate{
    func filterFriends(gender:String,distenace:Int,status:String,relationship:String)
}
protocol FollowRequestDelegate{
    func follow_request(index: Int)
}
protocol EditEventBtnDelegate {
    func EditButton(id: Int)
}
protocol EditEventDelegate{
    func EditEvent(id: Int)
}
protocol CreateFundDelegate {
    func createFund()
}
protocol getAddressDelegate {
    func getAddress(address: String)
}
protocol comment_CountsDelegate {
   func comment_Count()
}
protocol deleteImageDelegate{
    func deleteImage()
}
protocol editPostDelegate{
    func editPost(newtext: String,postPrivacy: String)
}
protocol editCommentDelegate{
    func editComment(text: String)
}
protocol loadEventDelegate{
    func loadEvent(type: String)
}
protocol createLiveDelegate {
    func createLive(name:String)
}
protocol endLiveDelegate{
    func endLive()
}

protocol sendDonationDelegation {
    func sendAmount(amount:Int)
}

protocol paystackDelegate{
    func sendEmail(email: String)
}
