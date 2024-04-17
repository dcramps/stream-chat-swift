//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

/// Represents a list of channels matching to the specified query.
@available(iOS 13.0, *)
@MainActor public final class ChannelListState: ObservableObject {
    private let observer: Observer
    private let query: ChannelListQuery
    
    init(
        query: ChannelListQuery,
        dynamicFilter: ((ChatChannel) -> Bool)?,
        clientConfig: ChatClientConfig,
        channelListUpdater: ChannelListUpdater,
        database: DatabaseContainer,
        eventNotificationCenter: EventNotificationCenter
    ) {
        self.query = query
        observer = Observer(
            query: query,
            dynamicFilter: dynamicFilter,
            clientConfig: clientConfig,
            channelListUpdater: channelListUpdater,
            database: database,
            eventNotificationCenter: eventNotificationCenter
        )
        channels = observer.start(
            with: .init(channelsDidChange: { [weak self] in self?.channels = $0 })
        )
    }
    
    /// An array of channels for the specified ``ChannelListQuery``.
    @Published public internal(set) var channels = StreamCollection<ChatChannel>([])
}
