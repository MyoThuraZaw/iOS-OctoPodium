//
//  LanguageUsersTableDataSource.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageUsersTableDataSource : NSObject, TableViewDataSource {

    var searchOptions: SearchOptions
    
    var userSearcher: Users.GetList
    var latestPage: Page<User>!
    
    var isSearching = false
    var page: Page<User>
    
    weak var tableStateListener: TableStateListener?
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        self.page = Page<User>(items: [], currentPage: 1, totalPages: 1, totalCount: 0)
        userSearcher = Users.GetList(searchOptions: searchOptions)
    }
    
    func item(at indexPath: IndexPath) -> User {
        return page[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return page.localCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserRankingCell = tableView.dequeueReusableCellFor(indexPath)
        cell.render(with: UserPresenter(user: item(at: indexPath), ranking: indexPath.row + 1))
        return cell
    }
    
    func searchUsers(_ reset: Bool = false) {
        if isSearching { return }

        if reset {
            searchOptions.page = 1
            reallyFetchUsers()
            return
        }
        
        if let latestPage = self.latestPage {
            if latestPage.hasMorePages {
                searchOptions.page += 1
                reallyFetchUsers()
            }
        } else {
            reallyFetchUsers()
        }
    }
    
    private func reallyFetchUsers() {
        isSearching = true
        userSearcher.call(success: usersSuccess, failure: failure)
    }
    
    func usersSuccess(_ usersPage: Page<User>) {
        isSearching = false
        latestPage = usersPage
        if usersPage.isFirstPage {
            self.page = usersPage
        } else {
            page.next(from: usersPage)
        }
        tableStateListener?.newDataArrived(page)
    }
    
    func failure(_ apiResponse: ApiResponse) {
        tableStateListener?.failedToGetData(apiResponse.status)
    }
    
    var hasMorePages: Bool {
        return page.hasMorePages
    }

    var totalCount: Int {
        return page.totalCount
    }
}
