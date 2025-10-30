////
////  ViewController.swift
////  ios101-project5-tumbler
////
//
//import UIKit
//import Nuke
//
//class ViewController: UIViewController {
//
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    private var posts: [Post] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        tableView.estimatedRowHeight = 320
//        tableView.rowHeight = UITableView.automaticDimension
//
//        
//        fetchPosts()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           posts.count
//       }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
//               fatalError("Storyboard cell identifier/class mismatch for PostCell")
//           }
//           cell.configure(with: posts[indexPath.row])
//           return cell
//       }
//
//
//
//
//    func fetchPosts() {
//        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
//        let session = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("❌ Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
//                print("❌ Response error: \(String(describing: response))")
//                return
//            }
//
//            guard let data = data else {
//                print("❌ Data is NIL")
//                return
//            }
//
//            do {
//                let blog = try JSONDecoder().decode(Blog.self, from: data)
//                let fetchedPosts = blog.response.posts
//
//                DispatchQueue.main.async { [weak self] in
//                    self?.posts = fetchedPosts
//                    self?.tableView.reloadData()
//                    let posts = blog.response.posts
//
//
//                    print("✅ We got \(posts.count) posts!")
//                    for post in posts {
//                        print("🍏 Summary: \(post.summary)")
//                    }
//                }
//
//            } catch {
//                print("❌ Error decoding JSON: \(error.localizedDescription)")
//            }
//        }
//        session.resume()
//    }
//}
//
//  ViewController.swift
//  ios101-project5-tumblr
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    // Store the decoded posts (your Post type)
    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // If using Auto Layout in the cell:
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableView.automaticDimension

        fetchPosts()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            fatalError("Storyboard cell identifier/class mismatch for PostCell")
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }

    // MARK: - Networking (uses your Blog/Response/Post models)
    private func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                // Decodes into your Blog → Response → [Post]
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                let fetched = blog.response.posts
                DispatchQueue.main.async {
                    self?.posts = fetched
                    self?.tableView.reloadData()
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
