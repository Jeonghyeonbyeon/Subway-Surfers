using System;
using UnityEngine;

namespace AmazingAssets.CurvedWorld.Example
{
    public class Perspective2D_Restarter : MonoBehaviour
    {
        private void OnTriggerEnter2D(Collider2D other)
        {
            if (other.tag == "Player")
            {
                //SceneManager.LoadScene(Application.loadedLevelName);
                UnityEngine.SceneManagement.SceneManager.LoadScene(0);
            }
        }
    }
}
