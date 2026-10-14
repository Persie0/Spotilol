package com.project.lol.ui.components

import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import compose.icons.TablerIcons
import compose.icons.tablericons.Home
import compose.icons.tablericons.Search
import compose.icons.tablericons.Playlist

/**
 * Optional native shell around the existing Spotify WebView. Does not replace
 * Spotify content or playback; the WebView stays mounted between tab presses.
 */
@Composable
fun NativeBottomTabs(selectedTab: Int, onSelect: (Int) -> Unit) {
    NavigationBar(containerColor = MaterialTheme.colorScheme.surface) {
        NavigationBarItem(
            selected = selectedTab == 0,
            onClick = { onSelect(0) },
            icon = { Icon(TablerIcons.Home, contentDescription = null) },
            label = { Text("Home") }
        )
        NavigationBarItem(
            selected = selectedTab == 1,
            onClick = { onSelect(1) },
            icon = { Icon(TablerIcons.Search, contentDescription = null) },
            label = { Text("Search") }
        )
        NavigationBarItem(
            selected = selectedTab == 2,
            onClick = { onSelect(2) },
            icon = { Icon(TablerIcons.Playlist, contentDescription = null) },
            label = { Text("Library") }
        )
    }
}
