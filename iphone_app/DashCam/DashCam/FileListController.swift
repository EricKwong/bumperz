//

import MediaPlayer
import UIKit
import AVKit

class FileListController: UITableViewController {
    
    class FileInfo {
        
        init(duration: Int, size: Int64, createdAt: NSDate, fullName: String) {
            self.duration = duration
            self.size = size
            self.createdAt = createdAt
            self.fullName = fullName
        }

        func dateAsString() -> String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = .MediumStyle
            return dateFormatter.stringFromDate(self.createdAt)
        }
        
        func durationAsString() -> String {
            return String(NSString(format: "%d seconds", self.duration))
        }
        
        func sizeAsString() -> String {
            return NSByteCountFormatter.stringFromByteCount(self.size, countStyle: NSByteCountFormatterCountStyle.File)
        }
        
        var duration: Int
        var size: Int64
        var createdAt: NSDate
        var fullName: String
    }

    var moviePlayer: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavBarItems()
    }

    func initNavBarItems() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "onClose")
        self.navigationItem.setLeftBarButtonItem(closeButton, animated: false)
    }
    
    func onClose() {
        self.parentViewController!.dismissViewControllerAnimated(true, completion:nil);
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listFilesInDocsDir().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoItemCellId", forIndexPath: indexPath)
        let fileInfo = listFilesInDocsDir()[indexPath.row]
        let filePath = fileInfo.fullName
        
        cell.textLabel?.text = fileInfo.dateAsString()
        
        let url = NSURL(string: filePath)
        // <converting image in thumbnail...
        let videoAsset = AVAsset(URL: url!)
        let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        
        let durationSeconds = CMTimeGetSeconds(videoAsset.duration);
        let midpoint = CMTimeMakeWithSeconds(durationSeconds / 2.0, 600);
        //generating image...
        let halfWayImage = try? imageGenerator.copyCGImageAtTime(midpoint, actualTime: nil)
        
        // show image in uiimage of tableviewcell....
        // ~G!!! why is the image missing sometimes?
        if (halfWayImage != nil) {
            cell.imageView?.image = UIImage(CGImage: halfWayImage!)
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteFile(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            let share = UITableViewRowAction(style: .Normal, title: "Share") { [weak self] _ in
                self?.shareFile(self!.fileNameByPath(indexPath), forIndexPath: indexPath)
            }
            share.backgroundColor = UIColor.grayColor()
            let delete = UITableViewRowAction(style: .Normal, title: "Delete") { [weak self] _ in
                self?.deleteFile(indexPath)
            }
            delete.backgroundColor = UIColor.redColor()
            return [delete, share]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let fileInfo = listFilesInDocsDir()[indexPath.row]
        let fileName = fileInfo.fullName
        print("FileName:\(fileName)!")
        let url = NSURL(string: fileName)
        
        moviePlayer = AVPlayerViewController()
        moviePlayer!.modalPresentationStyle = .FullScreen
        let player = AVPlayer(URL: url!)
        self.moviePlayer!.player = player
        self.presentViewController(self.moviePlayer!, animated:true, completion:nil)
        
        player.play()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func fileNameByPath(indexPath: NSIndexPath) -> NSURL {
        let fileInfo = listFilesInDocsDir()[indexPath.row]
        let urlStr = fileInfo.fullName
        return NSURL(string: urlStr)!
    }
    
    func deleteFile(indexPath: NSIndexPath) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete video", message: "The video will not be recoverable after deletion!", preferredStyle: .Alert)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Destructive) { action -> Void in
            let fileName = self.fileNameByPath(indexPath)
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(fileName)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } catch {
                print("File deletion error")
            }
        }
        actionSheetController.addAction(deleteAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
            self.tableView.editing = false
        }
        actionSheetController.addAction(cancelAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func shareFile(fileName: NSURL, forIndexPath indexPath: NSIndexPath) {
        print("Sharing a file %@s", fileName)

        let textToShare = "This video has been recording using DashCam app!"
        let objectsToShare = [textToShare, fileName]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: {
            self.tableView.editing = false
        })
    }
    
    func listFilesInDocsDir() -> [FileInfo] {
        var fileInfoArray = [FileInfo]()
        let fileManager = NSFileManager.defaultManager()
        let documentsUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        do {
            if let urls = try? fileManager.contentsOfDirectoryAtURL(documentsUrl,
                includingPropertiesForKeys: [NSURLNameKey, NSURLCreationDateKey, NSURLFileSizeKey], options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
                    for url in urls {
                        let fileInfo = FileInfo(duration: 0, size: 0, createdAt: NSDate(), fullName: "\(url)")
                        if let attributes : NSDictionary = try? fileManager.attributesOfItemAtPath(url.path!) {
                            fileInfo.size = Int64(attributes.fileSize())
                            fileInfo.createdAt = attributes.fileCreationDate()!
                            
                                // <converting image in thumbnail...
//                                let videoAsset = AVAsset(URL: url)
//                                fileInfo.duration = Int(CMTimeGetSeconds(videoAsset.duration))
                            
//                            fileInfo.duration = Int(CMTimeGetSeconds(AVURLAsset(URL: url).duration))
                        }
                        fileInfoArray.append(fileInfo)
                    }
            }
        }
        return fileInfoArray.sort { $0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedDescending }
    }

}
