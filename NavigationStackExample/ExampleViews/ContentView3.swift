import NavigationStack
import SwiftUI

struct ContentView3: View {
	@EnvironmentObject var navigationModel: NavigationModel

	// Freezes the state of `navigationModel.isAlternativeContentShowing("ContentView2")` to prevent transition animation glitches.
	let isView2Showing: Bool

	var body: some View {
		NavigationStackView("ContentView3") {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text("Content View 3")

					// It's safe to query the `hasAlternativeContentShowing` state from the model, because it will be frozen by the button view.
					// However, we could also just pass `true` because View3 is not the root view.
					DismissTopContentButton(hasAlternativeContentShowing: navigationModel.hasAlternativeContentShowing)

					Group {
						Button(action: {
							// Example of the shortcut pop transition, which is a move transition.
							navigationModel.popContent("ContentView1")
						}, label: {
							Text("Pop to root (View 1)")
						})

						// Using isAlternativeContentShowing from the model to show different sub-views will lead to animation glitches,
						// therefore use the frozen `isView2Showing` value.
						// if navigationModel.isAlternativeContentShowing("ContentView2") {
						if isView2Showing {
							Button(action: {
								navigationModel.popContent("ContentView2")
							}, label: {
								Text("Pop to View 2 (w/ animation)")
							})
						}

						Button(action: {
							// Example of a simple reset transition without animation.
							navigationModel.resetContent("ContentView2")
						}, label: {
							// Using isAlternativeContentShowing from the model to show different sub-views will lead to animation glitches,
							// therefore use the frozen `isView2Showing` value.
							// if navigationModel.isAlternativeContentShowing("ContentView2") {
							if isView2Showing {
								Text("Pop to View 2 (w/o animation)")
							} else {
								Text("Pop to View 2 (not available)")
							}
						})

						Button(action: {
							navigationModel.presentContent("ContentView3") {
								ContentView4(isPresented: navigationModel.contentShowingBinding("ContentView3"))
							}
						}, label: {
							Text("Present View 4")
						})
					}

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.orange.opacity(0.3))
		}
	}
}

struct ContentView3_Previews: PreviewProvider {
	static var previews: some View {
		ContentView3(isView2Showing: true)
			.environmentObject(NavigationModel())
	}
}
