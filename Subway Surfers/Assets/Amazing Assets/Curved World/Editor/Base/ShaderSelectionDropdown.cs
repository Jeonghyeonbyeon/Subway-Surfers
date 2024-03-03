using System;
using System.Linq;
using System.Collections.Generic;

using UnityEngine;
using UnityEditor;
using UnityEditor.IMGUI.Controls;


namespace AmazingAssets.CurvedWorldEditor
{
	internal class ShaderSelectionDropdown : AdvancedDropdown
	{
		private class ShaderDropdownItem : AdvancedDropdownItem
		{
			private string m_FullName;

			private string m_Prefix;

			public string fullName => m_FullName;

			public string prefix => m_Prefix; 

			public ShaderDropdownItem(string prefix, string fullName, string shaderName) 
				: base(shaderName)
			{
				m_FullName = fullName;
				m_Prefix = prefix;
				base.id = (prefix + fullName + shaderName).GetHashCode();
			}
		}

        private Action<object> m_OnSelectedShaderPopup;


		public ShaderSelectionDropdown(Action<object> onSelectedShaderPopup)
			: base(new AdvancedDropdownState())
		{
			base.minimumSize = new Vector2(270f, 308f);
			m_OnSelectedShaderPopup = onSelectedShaderPopup;
		}

		protected override AdvancedDropdownItem BuildRoot()
		{
			AdvancedDropdownItem root = new AdvancedDropdownItem("Shaders");
			ShaderInfo[] allShaderInfo = ShaderUtil.GetAllShaderInfo();
			List<string> list = new List<string>();
			List<string> list2 = new List<string>();
			List<string> list3 = new List<string>();
			List<string> list4 = new List<string>();
			ShaderInfo[] array = allShaderInfo;
			for (int i = 0; i < array.Length; i++)
			{
				ShaderInfo shaderInfo = array[i];
				if (!shaderInfo.name.StartsWith("Deprecated") && !shaderInfo.name.StartsWith("Hidden"))
				{
					if (shaderInfo.hasErrors)
					{
						list4.Add(shaderInfo.name);
					}
					else if (!shaderInfo.supported)
					{
						list3.Add(shaderInfo.name);
					}
					else if (shaderInfo.name.StartsWith("Legacy Shaders/"))
					{
						list2.Add(shaderInfo.name);
					}
					else
					{
						list.Add(shaderInfo.name);
					}
				}
			}
			list.Sort(delegate (string s1, string s2)
			{
				int num = s2.Count((char c) => c == '/') - s1.Count((char c) => c == '/');
				if (num == 0)
				{
					num = s1.CompareTo(s2);
				}
				return num;
			});
			list2.Sort();
			list3.Sort();
			list4.Sort();
			list.ForEach(delegate (string s)
			{
				AddShaderToMenu("", root, s, s);
			});
			if (list2.Any() || list3.Any() || list4.Any())
			{
				root.AddSeparator();
			}
			list2.ForEach(delegate (string s)
			{
				AddShaderToMenu("", root, s, s);
			});
			list3.ForEach(delegate (string s)
			{
				AddShaderToMenu("Not supported/", root, s, "Not supported/" + s);
			});
			list4.ForEach(delegate (string s)
			{
				AddShaderToMenu("Failed to compile/", root, s, "Failed to compile/" + s);
			});
			return root;
		}

		protected override void ItemSelected(AdvancedDropdownItem item)
		{
			m_OnSelectedShaderPopup(((ShaderDropdownItem)item).fullName);
		}

		private void AddShaderToMenu(string prefix, AdvancedDropdownItem parent, string fullShaderName, string shaderName)
		{
			string[] array = shaderName.Split('/');
			if (array.Length > 1)
			{
				AddShaderToMenu(prefix, FindOrCreateChild(parent, shaderName), fullShaderName, shaderName.Substring(array[0].Length + 1));
				return;
			}
			ShaderDropdownItem shaderDropdownItem = new ShaderDropdownItem(prefix, fullShaderName, shaderName);
			parent.AddChild(shaderDropdownItem);
		}

		private AdvancedDropdownItem FindOrCreateChild(AdvancedDropdownItem parent, string path)
		{
			string[] array = path.Split('/');
			string text = array[0];
			foreach (AdvancedDropdownItem child in parent.children)
			{
				if (child.name == text)
				{
					return child;
				}
			}
			AdvancedDropdownItem advancedDropdownItem = new AdvancedDropdownItem(text);
			parent.AddChild(advancedDropdownItem);
			return advancedDropdownItem;
		}
	}
}
